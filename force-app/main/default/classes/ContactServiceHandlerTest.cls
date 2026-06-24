@isTest(seeAllData=false)
private class ContactServiceHandlerTest {

    @isTest
    static void testGetContactNameReturnsName() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test.contact@example.com'
        );
        insert testContact;

        Test.startTest();
        String contactName = ContactServiceHandler.getContactName(testContact.Id);
        Test.stopTest();

        System.assertEquals('Test Contact', contactName, 'The returned contact name should match the inserted contact');
    }
}
