public with sharing class AccountContOppListCtrl {
    @Auraenabled 
	public static List<DetailsWrapper> fetchDetails(String userId) {
		List<Account> accList = [select id,name,BillingAddress from Account where ownerId =:userId limit 5];
		Map<String,DetailsWrapper> accIdToDetailsWrapper = new Map<String,DetailsWrapper>();
		Set<Id> accIdSet = new Set<Id>();
		for(Account acc : accList) {
			accIdSet.add(acc.id);
			DetailsWrapper dw = new DetailsWrapper();
			dw.accoundId = acc.Id;
			dw.accoundName = acc.name;
			dw.accoundbillingState = String.valueOf(acc.BillingAddress);
			accIdToDetailsWrapper.put(acc.Id, dw);
		}
		
		List<Opportunity> oppList = [select id,name,Amount,accountId from Opportunity where accountId IN: accIdSet order by amount desc nulls last, createdDate];
		List<Contact> contList = [select id,name,phone,email,accountId from Contact where accountId In: accIdSet and Is_primary__c = true order by createdDate ];
		
		for(Contact cont : contList) {
			DetailsWrapper dw = accIdToDetailsWrapper.get(cont.accountId);
			if(String.isBlank(dw.contactName)) {
				dw.contactName = cont.Name;
				dw.contactPhone = cont.Phone;
				dw.contactEmail = cont.email;
				accIdToDetailsWrapper.put(cont.accountId, dw);
			}
		}
		for(Opportunity opp : oppList) {
			DetailsWrapper dw = accIdToDetailsWrapper.get(opp.accountId);
			if(String.isBlank(dw.oppName)) {
				dw.oppName = opp.Name;
				dw.amount = String.valueOf(opp.amount);
				accIdToDetailsWrapper.put(opp.accountId, dw);
			}
		}
		return accIdToDetailsWrapper.values();
	}
	
	public class DetailsWrapper {
		@Auraenabled public string accoundId;
		@Auraenabled public string accoundName;
		@Auraenabled public string accoundbillingState;
		@Auraenabled public string contactName;
		@Auraenabled public string contactPhone;
		@Auraenabled public string contactEmail;
		@Auraenabled public string oppName;
		@Auraenabled public string amount;
		
		public DetailsWrapper(){}
		public DetailsWrapper(String accoundId, string accoundName, string accoundbillingState, string contactName, string contactPhone, string contactEmail, string oppName, string amount) {
			this.accoundId = accoundId;
			this.accoundName = accoundName;
		    this.accoundbillingState = accoundbillingState;
		    this.contactName = contactName;
		    this.contactPhone = contactPhone;
		    this.contactEmail = contactEmail;
		    this.oppName = oppName;
		    this.amount = amount;
		}
	}
}