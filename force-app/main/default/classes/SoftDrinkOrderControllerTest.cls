@isTest(seeAllData=false)
private class SoftDrinkOrderControllerTest {

    @isTest
    static void testCreateSoftDrinkOrder() {
        Soft_Drink__c softDrink = new Soft_Drink__c(Name = 'Test Soft Drink');
        insert softDrink;

        SoftDrinkOrderController.Input input = new SoftDrinkOrderController.Input();
        input.softDrinkID = softDrink.Id;
        input.Quantity = 3;
        input.price = 12.5;

        List<SoftDrinkOrderController.Input> inputList = new List<SoftDrinkOrderController.Input>{ input };

        Test.startTest();
        List<Soft_Drink_Order__c> orderList = SoftDrinkOrderController.createSoftDrinkOrder(inputList);
        Test.stopTest();

        System.assertEquals(1, orderList.size(), 'One Soft Drink Order should be returned');

        Soft_Drink_Order__c order = orderList[0];
        System.assertNotEquals(null, order.Id, 'Inserted order should have an Id');
        System.assertEquals(softDrink.Id, order.Soft_Drink__c, 'Soft drink lookup should be set');
        System.assertEquals(3, order.Quantity__c, 'Quantity should match the input');
        System.assertEquals(12.5, order.Price__c, 'Price should match the input');

        Soft_Drink_Order__c insertedOrder = [
            SELECT Id, Soft_Drink__c, Quantity__c, Price__c
            FROM Soft_Drink_Order__c
            WHERE Id = :order.Id
        ];

        System.assertEquals(softDrink.Id, insertedOrder.Soft_Drink__c, 'Saved order should reference the correct soft drink');
        System.assertEquals(3, insertedOrder.Quantity__c, 'Saved order quantity should match');
        System.assertEquals(12.5, insertedOrder.Price__c, 'Saved order price should match');
    }
}
