@isTest
public with sharing class AccountControllerTest {
    
    @isTest
    static void testGetAccounts() {
        // Create test accounts
        Account account1 = new Account(Name = 'Test Account 1', Industry = 'Technology ');
        Account account2 = new Account(Name = 'Test Account 2', Industry = 'Finance');
        insert new List<Account>{account1, account2};   

        // Call the method to get accounts
        List<Account> accounts = AccountController.getAccounts();
        // Assert that the returned accounts are correct
        System.assertEquals(2, accounts.size());
        System.assertEquals('Test Account 1', accounts[0].Name);
        System.assertEquals('Test Account 2', accounts[1].Name);
    }
}