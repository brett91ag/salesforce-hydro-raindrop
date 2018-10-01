global class CodeGenerator implements Process.Plugin
{    
    global Process.PluginResult invoke(Process.PluginRequest request)
    {   
        Map<String, Object> result = new Map<String, Object>();  
         
        String rand = string.valueof(Math.abs(Crypto.getRandomInteger()));
        String code = rand.substring(0,6);
        result.put('code', code);
         
        return new Process.PluginResult(result);
    }
 
    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description = 'This plug-in generates a random 6-digit code';
        result.tag = 'Identity';
         
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {};
         
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('code',
                Process.PluginDescribeResult.ParameterType.STRING)
        };
            
        return result;
    }
}