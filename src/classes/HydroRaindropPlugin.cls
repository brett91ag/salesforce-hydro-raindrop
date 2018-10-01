global class HydroRaindropPlugin implements Process.Plugin
{    
    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description='This plug-in handles Hydro Raindrop Client-side authentication.';
        result.tag='Identity';
        
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter('environment', 'must be production or sandbox', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('hydroID', 'the users HydroID from the Hydro mobile app', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('application_id', 'the Application ID assigned to you by Hydrogen', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('client_id', 'the Client ID from the API credentials assigned to you by Hydrogen', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('client_secret', 'the Client Secret from the API credentials assigned to you by Hydrogen', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('code', 'the random code generated for the user to enter into the Hydro app', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('step', 'which Hydro function to call', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('access_token_IN', 'the OAuth2 authentication token', Process.PluginDescribeResult.ParameterType.STRING, true)
                };
                    
                    result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
                        new Process.PluginDescribeResult.OutputParameter('IsValid', 'True if the operation was successful, false otherwise', Process.PluginDescribeResult.ParameterType.Boolean),
                            new Process.PluginDescribeResult.OutputParameter('access_token_OUT', 'the Oath2 authentication token', Process.PluginDescribeResult.ParameterType.STRING)
                            };
                                
                                return result;
    }
    
    global Process.PluginResult invoke(Process.PluginRequest request)
    {   
        Boolean status = false;
        Map<String, Object> result = new Map<String, Object>();
        String access_token;
        
        String environment = (String)request.inputParameters.get('environment');
        String hydroID = (String)request.inputParameters.get('hydroID');
        String application_id = (String)request.inputParameters.get('application_id');
        String client_id = (String)request.inputParameters.get('client_id');
        String client_secret = (String)request.inputParameters.get('client_secret');
        String code = (String)request.inputParameters.get('code');
        String step = (String)request.inputParameters.get('step');
        String access_token_IN = (String)request.inputParameters.get('access_token_IN');
        
        String base_url = 'https://sandbox.hydrogenplatform.com/hydro/v1';
        String auth_url = 'https://sandbox.hydrogenplatform.com/authorization/v1/oauth/token?grant_type=client_credentials';
        if (environment == 'production') {
            base_url = 'https://api.hydrogenplatform.com/hydro/v1';
            auth_url = 'https://api.hydrogenplatform.com/authorization/v1/oauth/token?grant_type=client_credentials';
        }
        
        // if access token is missing then perform OAuth2 authorization
        if (access_token_IN == null) 
            access_token = authorize(auth_url, client_id, client_secret);
        else
            access_token = access_token_IN;
        result.put('access_token_OUT', access_token);
       
        // choose which action to take based on 'step' input
        if (access_token != null) {
            if (step == 'verify') {
                status = verifySignature(base_url, hydroID, code, application_id, access_token);
                
            } else if (step == 'register') {
                status = registerUser(base_url, hydroID, application_id, access_token);
                
            } else if (step == 'verifyNew') {
                status = verifyNewUser(base_url, hydroID, code, application_id, access_token);
                
            } else if (step == 'unregister') {
                status = unregisterUser(base_url, hydroID, application_id, access_token);
            }
        }
        
        result.put('IsValid', status);
        return new Process.PluginResult(result);
    }
    
    // perform OAuth2 authorization, returns the auth token if successful
    private String authorize(String auth_url, String client_id, String client_secret) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(auth_url);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf(client_id + ':' + client_secret);
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) jsonObj.get('access_token');
        } else {
            return null;
        }
    }
    
    // verify user entered correct code through Hydro API
    private Boolean verifySignature(String base_url, String hydro_id, String message, String application_id, String access_token) {
        HttpRequest req = new HttpRequest();
        String full_url = base_url + '/verify_signature?message=' + message + '&hydro_id=' + hydro_id + '&application_id=' + application_id;
        req.setEndpoint(full_url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + access_token);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            return true;
        } else {
            return false;
        }
    }
    
    // register user to the application through Hydro API
    private Boolean registerUser(String base_url, String hydro_id, String application_id, String access_token) {
        HttpRequest req = new HttpRequest();
        String full_url = base_url + '/application/client';
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('hydro_id', hydro_id);
        gen.writeStringField('application_id', application_id);
        gen.writeEndObject();
        String body = gen.getAsString();
        
        req.setEndpoint(full_url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + access_token);
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            return true;
        } else {
            return false;
        }
    }
    
    // verify user entered correct code through Hydro API, then save their HydroID
    private Boolean verifyNewUser(String base_url, String hydro_id, String message, String application_id, String access_token) {
        Boolean stat = false;
        
        stat = verifySignature(base_url, hydro_id, message, application_id, access_token);
        
        // if user supplied correct code then save HydroID to their user record
        if (stat) {
            List<User> userFieldUpdate = new List<User>();
            for(User u : [Select HydroID__c From User Where Id =: UserInfo.getUserId()]){
                u.HydroID__c = hydro_id;
                userFieldUpdate.add(u);
            }
            if(!userFieldUpdate.isEmpty()){
                update userFieldUpdate;
            }        
        }
        
        return stat;
    }
    
    // unregister the user from the application through Hydro API
    Private Boolean unregisterUser(String base_url, String hydro_id, String application_id, String access_token) {
        HttpRequest req = new HttpRequest();
        String full_url = base_url + '/application/client?hydro_id=' + hydro_id + '&application_id=' + application_id;
        req.setEndpoint(full_url);
        req.setMethod('DELETE');
        req.setHeader('Authorization', 'Bearer ' + access_token);
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 204) {
            return true;
        } else {
            return false;
        }
    }
    
}