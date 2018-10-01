@isTest
private class HydroRaindropPluginTest
{
    static testMethod void describeTest() {

        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Process.PluginDescribeResult result = hrp.describe();
        
        System.AssertEquals(result.inputParameters.size(), 8);
        System.AssertEquals(result.outputParameters.size(), 2);
     }
 
     static testMethod void testAuthorize() {
     
        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('environment', 'sandbox');
        inputParams.put('hydroID', 'abc123');
        inputParams.put('application_id', 'abc123');
        inputParams.put('client_id', 'abc123');
        inputParams.put('client_secret', 'abc123');
        inputParams.put('code', '');
        inputParams.put('step', '');
        inputParams.put('access_token_IN', null);
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HydroMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = hrp.invoke(request);
        
        System.AssertEquals('abcd1234',result.outputParameters.get('access_token_OUT'));
    }

    static testMethod void testVerifySignature() {
     
        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('environment', 'sandbox');
        inputParams.put('hydroID', 'abc123');
        inputParams.put('application_id', 'abc123');
        inputParams.put('client_id', 'abc123');
        inputParams.put('client_secret', 'abc123');
        inputParams.put('code', 'a0b1c2');
        inputParams.put('step', 'verify');
        inputParams.put('access_token_IN', 'abcd1234');
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HydroMockResponse');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = hrp.invoke(request);
        
        System.AssertEquals(false,result.outputParameters.get('IsValid'));
    }

    static testMethod void testRegisterUser() {
     
        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('environment', 'sandbox');
        inputParams.put('hydroID', 'abc123');
        inputParams.put('application_id', 'abc123');
        inputParams.put('client_id', 'abc123');
        inputParams.put('client_secret', 'abc123');
        inputParams.put('code', '');
        inputParams.put('step', 'register');
        inputParams.put('access_token_IN', 'abcd1234');
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HydroMockResponse');
        mock.setStatusCode(201);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = hrp.invoke(request);
        
        System.AssertEquals(true,result.outputParameters.get('IsValid'));
    }

    static testMethod void testVerifyNewUser() {
     
        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('environment', 'sandbox');
        inputParams.put('hydroID', 'abc123');
        inputParams.put('application_id', 'abc123');
        inputParams.put('client_id', 'abc123');
        inputParams.put('client_secret', 'abc123');
        inputParams.put('code', 'a0b1c2');
        inputParams.put('step', 'verifyNew');
        inputParams.put('access_token_IN', 'abcd1234');
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HydroMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = hrp.invoke(request);
        
        System.AssertEquals(true,result.outputParameters.get('IsValid'));
    }

    static testMethod void testUnregisterUser() {
     
        HydroRaindropPlugin hrp = new HydroRaindropPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('environment', 'production');
        inputParams.put('hydroID', 'abc123');
        inputParams.put('application_id', 'abc123');
        inputParams.put('client_id', 'abc123');
        inputParams.put('client_secret', 'abc123');
        inputParams.put('code', '');
        inputParams.put('step', 'unregister');
        inputParams.put('access_token_IN', 'abcd1234');
 
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('HydroMockResponse');
        mock.setStatusCode(204);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = hrp.invoke(request);
        
        System.AssertEquals(true,result.outputParameters.get('IsValid'));
    }
}