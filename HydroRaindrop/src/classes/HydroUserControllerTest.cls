@isTest
private class HydroUserControllerTest
{
    static testMethod void doTest() {
         HydroUserController huc = new HydroUserController();
         List<User> users = huc.getUsers();
         System.assert(users != null);
     }
}