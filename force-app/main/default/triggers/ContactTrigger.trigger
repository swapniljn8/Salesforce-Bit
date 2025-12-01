trigger ContactTrigger on Contact (before insert, before update) {
    if(trigger.isbefore) {
        if(trigger.isUpdate) {
            //ContactTriggerController.beforeUpdate(trigger.new, trigger.oldMap, trigger.old);
        }
    }
    // Set of Account Ids to be updated
    Set<Id> accountIdsToUpdate = new Set<Id>();
    //Scenario : When a Contact is updated, update the Account record with the number of Contacts of Type1 and Type2
    // Iterate through inserted or updated Contacts
    for (Contact contact : Trigger.new) {
        if (contact.AccountId != null) {
            accountIdsToUpdate.add(contact.AccountId);
        }
    }

    // Query Accounts to update
    List<Account> accountsToUpdate = new List<Account>();
    if (!accountIdsToUpdate.isEmpty()) {
        accountsToUpdate = [SELECT Id, Type1_Count__c, Type2_Count__c 
                            FROM Account 
                            WHERE Id IN :accountIdsToUpdate];
    }

    // Query Contacts to get Type counts
    Map<Id, Integer> typeCounts = new Map<Id, Integer>(); 
    for (AggregateResult ar : [SELECT AccountId, Type__c, COUNT(Id) 
                               FROM Contact 
                               WHERE AccountId IN :accountIdsToUpdate 
                               GROUP BY AccountId, Type__c]) {
        String contactType = (String)ar.get('Type__c');
        if (contactType == 'Type1') {
            typeCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('expr0')); 
        } else if (contactType == 'Type2') {
            typeCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('expr0')); 
        }
    }

    // Update Account records with calculated counts
    for (Account account : accountsToUpdate) {
        account.Type1_Count__c = typeCounts.containsKey(account.Id + '_Type1') ? typeCounts.get(account.Id + '_Type1') : 0;
        account.Type2_Count__c = typeCounts.containsKey(account.Id + '_Type2') ? typeCounts.get(account.Id + '_Type2') : 0;
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}