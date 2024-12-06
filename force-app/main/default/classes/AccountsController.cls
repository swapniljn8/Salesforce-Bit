public with sharing class AccountsController {
    @AuraEnabled
    public static List<Account> getAccountDetails(String recordId){
        try {
            return [select id,name,Website,phone from Account where id=: recordId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}