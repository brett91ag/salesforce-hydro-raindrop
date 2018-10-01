public class HydroUserController {
    
    public List<User> getUsers() {
    
        List<User> results = Database.query(
            'SELECT Id, Name, Email, HydroID__c ' +
            'FROM User ' +
            'WHERE UserType != \'AutomatedProcess\' ' +
            'ORDER BY LastName, FirstName ASC ' +
            'LIMIT 2000'
        );
        return results;
    }   
}