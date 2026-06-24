@isTest(seeAllData=false)
private class SoftDrinkOrderStatusTest {

    @isTest
    static void testGetStatusReturnsOrderStatus() {
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get('Soft_Drink_Order__c').getDescribe();
        Schema.DescribeFieldResult fieldDescribe = describeResult.fields.getMap().get('Status__c').getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
        String validStatus = picklistValues.isEmpty() ? null : picklistValues[0].getValue();
        System.assertNotEquals(null, validStatus, 'There should be at least one valid Status__c picklist value');

        Soft_Drink_Order__c softDrinkOrder = new Soft_Drink_Order__c(
            Order_Number__c = 101,
            Status__c = validStatus
        );
        insert softDrinkOrder;

        List<Integer> inputOrderNumbers = new List<Integer>{101};

        Test.startTest();
        List<String> statusList = SoftDrinkOrderStatus.getStatus(inputOrderNumbers);
        Test.stopTest();

        System.assertEquals(1, statusList.size(), 'Expected one status result');
        System.assertEquals(validStatus, statusList[0], 'Expected the status to match the inserted order');
    }
}
