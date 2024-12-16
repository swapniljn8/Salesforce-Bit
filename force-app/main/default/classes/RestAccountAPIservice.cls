//swapnil912-dev-ed.my.salesforce.com-swapniljain811@gmail.com
@RestResource(urlMapping='/Account/*')
global with sharing class RestAccountAPIservice {
    @HttpPost
    global static String postAccounts() {
        try {
            system.debug('Received response'+RestContext.request.requestBody.toString());
            String jsonAccounts = RestContext.request.requestBody.toString();
            system.debug('JSON === >'+jsonAccounts) ;
            List<Account> deserializedAccounts = (List<Account>) JSON.deserialize(jsonAccounts, List<Account>.class);
            List<Account> accList = new List<Account>();
            for (Account acc : deserializedAccounts) {
                system.debug ('acc === >'+acc) ;
                Account account = new Account();
                String accName = acc.Name;
                account.Name = accName;
                account.Source_Name__c = 'swapnil-jain-dev-ed.lightning.force.com';
                accList.add(account);
            }
            if (!accList.isEmpty()) {
                    List<sObject> sobjectList = new List<sObject>();
                    sobjectList = (List<SObject>) accList;
                    insert sobjectList;
                    system.debug('deserail === >'+accList);
                    return 'Record Processed successfully';
            } else {
                    return 'No valid records to process.';
            }
        }
        catch(Exception ex) {
            System.debug('Error: ' + ex.getMessage());
            return 'Error processing records: ' + ex.getMessage();
        }
    }
    @HttpGet
    global static List<Account> getAccounts() {
        try {
            system.debug('Received response get='+RestContext.request.toString());
            List<Account> acc = [select id,name from Account limit 10];
            system.debug ('accList get === >'+acc) ;
            return acc;
        }
        catch(Exception ex) {
            System.debug('Error: ' + ex.getMessage());
            return null;
        }
    }
}