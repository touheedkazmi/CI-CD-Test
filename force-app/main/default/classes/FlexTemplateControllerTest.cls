@isTest(seeAllData=false)
private class FlexTemplateControllerTest {

    private class ConnectApiMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"generations":[{"text":"Mock template response"}]}');
            return res;
        }
    }

    @isTest
    static void testGetFlexTemplateResponseReturnsMockResult() {
        Account acc = new Account(Name = 'Test Account', Rating = 'A');
        insert acc;

        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User adminUser = new User(
            Username = 'flexTemplateTest' + System.currentTimeMillis() + '@example.com',
            Email = 'flexTemplateTest@example.com',
            LastName = 'Test',
            Alias = 'fttest',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = adminProfile.Id
        );
        insert adminUser;

        Test.startTest();
        System.runAs(adminUser) {
            Product2 product1 = new Product2(Name = 'Product 1', Rating__c = 'A');
            Product2 product2 = new Product2(Name = 'Product 2', Rating__c = 'A');
            insert new List<Product2>{ product1, product2 };

            Soft_Drink__c drink1 = new Soft_Drink__c(Name = 'Drink 1', Rating__c = 'A');
            Soft_Drink__c drink2 = new Soft_Drink__c(Name = 'Drink 2', Rating__c = 'A');
            insert new List<Soft_Drink__c>{ drink1, drink2 };

            Test.setMock(HttpCalloutMock.class, new ConnectApiMock());
            String result = FlexTemplateController.getFlexTemplateResponse('Test Account', 'A');
            System.assertEquals('Mock template response', result);
        }
        Test.stopTest();
    }
}
