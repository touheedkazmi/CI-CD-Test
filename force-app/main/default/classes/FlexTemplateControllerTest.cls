@isTest(seeAllData=false)
private class FlexTemplateControllerTest {

    private class ConnectApiMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{
                "generations": [
                    {"text": "Mock template response"}
                ]
            }');
            return res;
        }
    }

    @isTest
    static void testGetFlexTemplateResponseReturnsMockResult() {
        Account acc = new Account(Name = 'Test Account', Rating = 'A');
        insert acc;

        Product2 product1 = new Product2(Name = 'Product 1', Rating__c = 'A');
        Product2 product2 = new Product2(Name = 'Product 2', Rating__c = 'A');
        insert new List<Product2>{ product1, product2 };

        Soft_Drink__c drink1 = new Soft_Drink__c(Name = 'Drink 1', Rating__c = 'A');
        Soft_Drink__c drink2 = new Soft_Drink__c(Name = 'Drink 2', Rating__c = 'A');
        insert new List<Soft_Drink__c>{ drink1, drink2 };

        Test.setMock(HttpCalloutMock.class, new ConnectApiMock());

        Test.startTest();
        String result = FlexTemplateController.getFlexTemplateResponse('Test Account', 'A');
        Test.stopTest();

        System.assertEquals('Mock template response', result);
    }
}
