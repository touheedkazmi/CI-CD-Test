@isTest(seeAllData=true)
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
        Map<String, Schema.SObjectField> sdFieldMap = Schema.getGlobalDescribe().containsKey('Soft_Drink__c') ? Schema.getGlobalDescribe().get('Soft_Drink__c').getDescribe().fields.getMap() : new Map<String, Schema.SObjectField>();
        String ratingValue = 'A';
        if (sdFieldMap.containsKey('Rating__c')) {
            List<Schema.PicklistEntry> softDrinkRatings = sdFieldMap.get('Rating__c').getDescribe().getPicklistValues();
            ratingValue = softDrinkRatings.isEmpty() ? 'A' : softDrinkRatings[0].getValue();
        }

        Account acc = new Account(Name = 'Test Account', Rating = ratingValue);
        insert acc;

        Map<String, Schema.SObjectField> productFieldMap = Schema.getGlobalDescribe().containsKey('Product2') ? Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap() : new Map<String, Schema.SObjectField>();
        if (productFieldMap.containsKey('Rating__c')) {
            Schema.DescribeFieldResult productRatingFieldDescribe = productFieldMap.get('Rating__c').getDescribe();
            if (productRatingFieldDescribe.isCreateable()) {
                Product2 product1 = new Product2(Name = 'Product 1', Rating__c = ratingValue);
                Product2 product2 = new Product2(Name = 'Product 2', Rating__c = ratingValue);
                insert new List<Product2>{ product1, product2 };
            } else {
                // If not createable, don't attempt to insert; controller checks field existence before querying
            }
        }

        if (sdFieldMap.containsKey('Rating__c')) {
            Schema.DescribeFieldResult softDrinkRatingFieldDescribe = sdFieldMap.get('Rating__c').getDescribe();
            if (softDrinkRatingFieldDescribe.isCreateable()) {
                Soft_Drink__c drink1 = new Soft_Drink__c(Name = 'Drink 1', Rating__c = ratingValue);
                Soft_Drink__c drink2 = new Soft_Drink__c(Name = 'Drink 2', Rating__c = ratingValue);
                insert new List<Soft_Drink__c>{ drink1, drink2 };
            } else {
                // skip creating soft drinks when Rating__c is not createable 
            }
        }

        Test.setMock(HttpCalloutMock.class, new ConnectApiMock());

        Test.startTest();
        String result = FlexTemplateController.getFlexTemplateResponse('Test Account', ratingValue);
        Test.stopTest();

        System.assertEquals('Mock template response', result);
    }
}
