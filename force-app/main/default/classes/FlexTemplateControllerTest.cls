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
        Schema.DescribeFieldResult softDrinkFieldDescribe = Schema.getGlobalDescribe().get('Soft_Drink__c').getDescribe().fields.getMap().get('Rating__c').getDescribe();
        List<Schema.PicklistEntry> softDrinkRatings = softDrinkFieldDescribe.getPicklistValues();
        String ratingValue = softDrinkRatings.isEmpty() ? 'A' : softDrinkRatings[0].getValue();

        Account acc = new Account(Name = 'Test Account', Rating = ratingValue);
        insert acc;

        Schema.DescribeFieldResult productRatingFieldDescribe = Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().get('Rating__c').getDescribe();
        Boolean productRatingCreateable = productRatingFieldDescribe.isCreateable();
        if (productRatingCreateable) {
            Product2 product1 = new Product2(Name = 'Product 1', Rating__c = ratingValue);
            Product2 product2 = new Product2(Name = 'Product 2', Rating__c = ratingValue);
            insert new List<Product2>{ product1, product2 };
        } else {
            List<Product2> existingProducts = [SELECT Id FROM Product2 WHERE Rating__c = :ratingValue LIMIT 2];
            System.assertEquals(2, existingProducts.size(), 'Need two existing Product2 records with Rating__c accessible');
        }

        Schema.DescribeFieldResult softDrinkRatingFieldDescribe = Schema.getGlobalDescribe().get('Soft_Drink__c').getDescribe().fields.getMap().get('Rating__c').getDescribe();
        Boolean softDrinkRatingCreateable = softDrinkRatingFieldDescribe.isCreateable();
        if (softDrinkRatingCreateable) {
            Soft_Drink__c drink1 = new Soft_Drink__c(Name = 'Drink 1', Rating__c = ratingValue);
            Soft_Drink__c drink2 = new Soft_Drink__c(Name = 'Drink 2', Rating__c = ratingValue);
            insert new List<Soft_Drink__c>{ drink1, drink2 };
        } else {
            List<Soft_Drink__c> existingSoftDrinks = [SELECT Id FROM Soft_Drink__c WHERE Rating__c = :ratingValue LIMIT 2];
            System.assertEquals(2, existingSoftDrinks.size(), 'Need two existing Soft_Drink__c records with Rating__c accessible');
        }

        Test.setMock(HttpCalloutMock.class, new ConnectApiMock());

        Test.startTest();
        String result = FlexTemplateController.getFlexTemplateResponse('Test Account', ratingValue);
        Test.stopTest();

        System.assertEquals('Mock template response', result);
    }
}
