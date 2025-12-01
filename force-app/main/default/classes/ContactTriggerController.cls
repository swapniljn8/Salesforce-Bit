public without sharing class ContactTriggerController {
    public ContactTriggerController() {}
    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap, List<Contact> oldList, Map<Id, Contact> newMap) {
        Set<Id> idAcc = new Set<ID>();
        for(Contact con : newList) {
            if(con.AccountId != null) {
                idAcc.add(con.AccountId);
            }
            if(newList != oldList) {
                ContactTriggerHelper.updateAccountfromContact(idAcc);
            }
            
        }
    }
    public static void beforeInsert(List<Contact> newList, Map<Id, Contact> oldMap, List<Contact> oldList, Map<Id, Contact> newMap) {
        Set<Id> idAcc = new Set<ID>();
        for(Contact con : newList) {
            if(con.AccountId != null) {
                idAcc.add(con.AccountId);
            }
            if(newList != oldList) {
                ContactTriggerHelper.updateAccountfromContact(idAcc);
            }
            
        }
    }
    public static void afterInsert(List<Contact> newList, Map<Id, Contact> oldMap, List<Contact> oldList, Map<Id, Contact> newMap) {}
    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap, List<Contact> oldList, Map<Id, Contact> newMap) {}
    
    @AuraEnabled
    public static List<ContactWrapper> fetchContact() {
        List<Contact> contList = [select id,name,phone,email from Contact limit 5];
        List<ContactWrapper> wrapperList = new List<ContactWrapper>();
        for(Contact cont : contList) {
            ContactWrapper wrapper = new ContactWrapper(cont.Id, cont.name, String.valueOf(cont.Phone), String.valueOf(cont.Email));
            wrapperList.add(wrapper);
        }
        system.debug('data='+JSON.serialize(wrapperList));
        return wrapperList;
    }
    
    @Auraenabled
    public static String UpdateContacts(String contacts) {
        List<ContactWrapper> wrapperList = (List<ContactWrapper>) JSON.deserialize(contacts, List<ContactWrapper>.class);
        List<Contact> contListToUpdate = new List<Contact>();
        for(ContactWrapper wrapper : wrapperList) {
            Contact con = new Contact(Id = wrapper.id);
            con.Phone = wrapper.mobile;
            contListToUpdate.add(con);
        }
        if(!contListToUpdate.isEmpty()) {
            Database.SaveResult[] result = Database.update(contListToUpdate,false);
            if(result[0].isSuccess()) {
                return 'Success';
            }
            else {
                String errmsg = '';
                for(Database.Error err : result[0].getErrors()) {
                    errmsg += (err.getStatusCode() + ': ' + err.getMessage() + 'Account fields that affected this error: ' + err.getFields());
                }
                return errmsg;
            }
        }
        return '';
    }
    
    public class ContactWrapper {
        @Auraenabled public String id;
        @Auraenabled public String name;
        @Auraenabled public String email;
        @Auraenabled public String mobile;
        
        public ContactWrapper(String id, String name, String email, String mobile) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.mobile = mobile;
        }
    }
}