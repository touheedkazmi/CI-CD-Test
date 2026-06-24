@isTest
public with sharing class ContactDetailsTest {

    @isTest
    static void testGetContactName() {
        // Create a test contact
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe');
        insert testContact;

        // Call the method to get the contact name
        String contactNameUpdated = ContactDetails.getContactName(testContact.Id);

        // Assert that the returned name is correct
        System.assertEquals('John Doe', contactNameUpdated);
    }
    
}