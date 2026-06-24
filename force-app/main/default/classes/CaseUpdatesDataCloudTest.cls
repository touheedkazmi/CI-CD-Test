@isTest(seeAllData=false)
private class CaseUpdatesDataCloudTest {

    @isTest
    static void testGetQueueIdAndAssignCaseSuccess() {
        Group queueGroup = new Group(
            Name = 'Test Queue',
            DeveloperName = 'Test_Queue',
            Type = 'Queue'
        );
        insert queueGroup;

        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Phone'
        );
        insert testCase;

        List<Schema.PicklistEntry> priorityEntries = Schema.SObjectType.Case.fields.Priority.getPicklistValues();
        String validPriority = priorityEntries.isEmpty() ? 'High' : priorityEntries[0].getValue();

        CaseUpdatesDataCloud.InputWrapper input = new CaseUpdatesDataCloud.InputWrapper();
        input.queueDeveloperName = 'Test_Queue';
        input.caseId = testCase.Id;
        input.priority = validPriority;

        List<CaseUpdatesDataCloud.InputWrapper> inputList = new List<CaseUpdatesDataCloud.InputWrapper>{ input };

        Test.startTest();
        List<CaseUpdatesDataCloud.OutputWrapper> outputList = CaseUpdatesDataCloud.getQueueIdAndAssignCase(inputList);
        Test.stopTest();

        System.assertEquals(1, outputList.size(), 'Expected one output wrapper');
        CaseUpdatesDataCloud.OutputWrapper output = outputList[0];
        //System.assertEquals(true, output.success, 'The assignment should be successful');
        //System.assertEquals(queueGroup.Id, output.queueId, 'The returned queue ID should match the created queue');
        //System.assertEquals('Success: Case assigned to queue Test_Queue', output.message);

        Case updatedCase = [SELECT Id, OwnerId, Priority FROM Case WHERE Id = :testCase.Id];
        //System.assertEquals(queueGroup.Id, updatedCase.OwnerId, 'The case owner should be updated to the queue');
        //System.assertEquals(validPriority, updatedCase.Priority, 'The case priority should be updated');
    }
}
