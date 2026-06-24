@isTest(seeAllData=false)
private class AccountSummaryPromptTest {

    @isTest
    static void testGetSoftDrinkDataReturnsPrompt() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        List<Schema.PicklistEntry> ratingEntries = Schema.SObjectType.Soft_Drink__c.fields.Rating__c.getDescribe().getPicklistValues();
        String validRating = ratingEntries.isEmpty() ? null : ratingEntries[0].getValue();
        System.assertNotEquals(null, validRating, 'There should be at least one valid Rating__c picklist value');

        Soft_Drink__c drink = new Soft_Drink__c(Name = 'Test Drink', Rating__c = validRating);
        insert drink;

        Soft_Drink_Order__c order = new Soft_Drink_Order__c(
            Soft_Drink__c = drink.Id,
            Account__c = acc.Id,
            Quantity__c = 2
        );
        insert order;

        Case caseRecord = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Reason = 'Question',
            Description = 'Test case description'
        );
        insert caseRecord;

        AccountSummaryPrompt.Request requestWrapper = new AccountSummaryPrompt.Request();
        requestWrapper.objectToSummarize = acc;

        List<AccountSummaryPrompt.Response> responses = AccountSummaryPrompt.getSoftDrinkData(
            new List<AccountSummaryPrompt.Request>{ requestWrapper }
        );

        System.assertEquals(1, responses.size(), 'Expected a single response');
        String prompt = responses[0].Prompt;
        System.assert(prompt.contains('Soft Drink Details:'), 'Expected soft drink details in the prompt');
        System.assert(prompt.contains('Case Details:- Subject , Reason , Description'), 'Expected case details in the prompt');
    }
}
