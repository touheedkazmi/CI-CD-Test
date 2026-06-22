public with sharing class ContactServiceHandler {
    
    public static String getContactName(String Id) {
        
        String name = [SELECT Name FROM Contact WHERE Id = :Id LIMIT 1
        ].Name;
        
        return name;

    }
}