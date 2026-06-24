@isTest
public with sharing class CaseCopilotTest {
    
    @isTest
    static void testCreateCase() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Prepare input for the invocable method
        CaseCopilot.Input input = new CaseCopilot.Input();
        input.Subject = 'Test Case Subject';
        input.Priority = 'High';
        input.Description = 'Test Case Description';
        input.AccountId = testAccount.Id;

        List<CaseCopilot.Input> inputWrapper = new List<CaseCopilot.Input>{input};

        // Call the invocable method
        Test.startTest();
        List<CaseCopilot.Output> outputList = CaseCopilot.createCase(inputWrapper);
        Test.stopTest();

        // Assert that a case was created
        System.assertEquals(1, outputList.size());
        Case createdCase = outputList[0].caseRec;
        System.assertNotEquals(null, createdCase);
        System.assertEquals('Test Case Subject', createdCase.Subject);
        System.assertEquals('High', createdCase.Priority);
        System.assertEquals('Test Case Description', createdCase.Description);
        System.assertEquals(testAccount.Id, createdCase.AccountId);
    }
}