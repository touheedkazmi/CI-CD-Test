public with sharing class AccountController {
    public AccountController() {

    }

    //this is to check auto deployment and to check if the class is working fine or not
    public static List<Account> getAccounts() {
        List<Account> accounts = [SELECT Id, Name, Industry FROM Account];
        System.debug('Accounts retrieved: ' + accounts);
        return accounts;

       
    }
}