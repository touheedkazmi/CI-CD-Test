@isTest
public with sharing class CaseUpdatesTest {

    @isTest
    static void testAssignCaseToQueue() {
        // Create a test queue
        Group testQueue = new Group(Name = 'Test Queue', DeveloperName = 'Test_Queue', Type = 'Queue');
        insert testQueue;

        // Create a test case
        Case testCase = new Case(Subject = 'Test Case', Status = 'New');
        insert testCase;

        // Prepare input for the invocable method
        CaseUpdates.InputWrapper input = new CaseUpdates.InputWrapper();
        input.queueDeveloperName = 'Test_Queue';
        input.caseId = testCase.Id;

        List<CaseUpdates.InputWrapper> inputList = new List<CaseUpdates.InputWrapper>{input};

        // Call the invocable method
        Test.startTest();
        List<CaseUpdates.OutputWrapper> outputList = CaseUpdates.getQueueIdAndAssignCase(inputList);
        Test.stopTest();

        // Assert that the case was assigned to the queue
        System.assertEquals(1, outputList.size());
        CaseUpdates.OutputWrapper output = outputList[0];
        System.assertEquals(true, output.success);
        System.assertEquals('Success: Case assigned to queue Test_Queue', output.message);

        // Verify that the case owner is updated to the queue
        Case updatedCase = [SELECT Id, OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(testQueue.Id, updatedCase.OwnerId);
    }

    
}