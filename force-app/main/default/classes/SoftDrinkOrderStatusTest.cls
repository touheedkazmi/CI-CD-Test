@isTest(seeAllData=false)
private class SoftDrinkOrderStatusTest {

    @isTest
    static void testGetStatusReturnsOrderStatus() {
        Soft_Drink_Order__c softDrinkOrder = new Soft_Drink_Order__c(
            Order_Number__c = 101,
            Status__c = 'Delivered'
        );
        insert softDrinkOrder;

        List<Integer> inputOrderNumbers = new List<Integer>{101};

        Test.startTest();
        List<String> statusList = SoftDrinkOrderStatus.getStatus(inputOrderNumbers);
        Test.stopTest();

        System.assertEquals(1, statusList.size(), 'Expected one status result');
        System.assertEquals('Delivered', statusList[0], 'Expected the status to match the inserted order');
    }
}
