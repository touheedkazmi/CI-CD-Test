public with sharing class ContactServiceHandler {
    
    //this is contact service handler class which is used to get the contact name by Id
    //adding more comments to explain the code
    public static String getContactName(String Id) {
        
        String name = [SELECT Name FROM Contact WHERE Id = :Id LIMIT 1
        ].Name;
        
        return name;

    }
}