public with sharing class ContactDetails {
    
    public static String getContactName(String Id) {

        String Name = [SELECT Name FROM Contact WHERE Id = :Id
        ].Name;
        return Name;
}