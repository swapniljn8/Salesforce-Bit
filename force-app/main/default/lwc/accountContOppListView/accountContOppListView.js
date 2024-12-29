import { LightningElement,track } from 'lwc';
import fetchAccount from '@salesforce/apex/AccountContOppListCtrl.fetchDetails';
import userId from '@salesforce/user/Id';
export default class AccountContOppListView extends LightningElement {
    @track accList = []
    connectedCallback() {
		this.displayAccountsRecords();
	}
	async displayAccountsRecords() {
		 await fetchAccount({
			'userId' : userId
		})
		.then(result => {
			this.accList = result
		})
		.catch(error => {
			log(error)
		})
	}
}