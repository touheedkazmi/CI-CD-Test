public with sharing class AccountController {
    public AccountController() {

    }

    public static List<Account> getAccounts() {
        List<Account> accounts = [SELECT Id, Name, Industry FROM Account];
        System.debug('Accounts retrieved: ' + accounts);
        System.debug('Test1');
        System.debug('Test2');
        return accounts;

       
    }
}