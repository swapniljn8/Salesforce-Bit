@RestResource(urlMapping='/Account/*')
global with sharing class RestAccountAPIservice {
       @HttpGet
    global static List<Account> getAccounts(){
        System.debug('GET Method has been called');
        return [Select Name, Phone from Account Limit 10];    }
    @HttpPost
    global static Account createAccount(String accountName){
             Account ac = new Account();
        ac.Name = accountName;
        ac.City2__c = 'jaipur';
        System.debug('Post Method has been called');
        insert ac;
        return ac;
    }
    @HttpDelete
    global static void doDelete() {
     System.debug('Delete Method has been called');
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account; 
    }
    global static Account putMethod(String accountName,String Phone){
        Account ac = new Account();
        ac.Name = accountName;
        ac.City2__c = 'jaipur';
        ac.Phone = Phone;
   System.debug('Put Method has been called');
        insert ac;
        return ac;
 }
 @HttpPatch
   global static ID updateAccountFields(){
        RestRequest req = RestContext.request;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Map<String,Object> mapObj = new Map<String,Object>();
        Account ac = [Select Id from Account where Id =:accountId];
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(req.requestBody.toString());
        System.debug('params'+params);
        for(String fieldName:params.keySet()){
            ac.put(fieldName, params.get(fieldName));
        }
        update ac;
        return ac.Id;
    }
    @HttpPut
   global static void bulkUpdate() {
    try {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        List<Account> accountsToUpdate = (List<Account>) JSON.deserialize(requestBody, List<Account>.class);
       
            Schema.SObjectField orgExternalField = Account.Fields.External_ID__c;
            System.debug('orgExternalField'+orgExternalField);
            Database.UpsertResult[] srList = Database.upsert(accountsToUpdate,orgExternalField,false);
         
            System.debug('srList'+srList);        
   
    } catch (Exception e) {      
       
        System.debug('message'+e.getMessage());
      System.debug('line no'+e.getLineNumber());
     }}}