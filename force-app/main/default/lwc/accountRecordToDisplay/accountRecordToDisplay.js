import { LightningElement,api,wire,track } from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountsController.getAccountDetails';
import {getRecord} from 'lightning/uiRecordApi';
import NAME from '@salesforce/schema/Account.Name';
import PHONE from '@salesforce/schema/Account.Phone';
import WEBSITE from '@salesforce/schema/Account.Website';
export default class AccountRecordToDisplay extends LightningElement {
    @api recordId;
    @track accountDetails = [];
    bypassImperative = false;
    bypassWireFunction = false;
    bypassWireProperty = false;
    radioButtonValue = '';
    options = [
        { label: 'Wire Function', value: 'WFun' },
        { label: 'Wire Propert', value: 'WProp' },
        { label: 'Imperative', value: 'Imperative' }        
    ]
    @wire(getRecord, {recordId : '$recordId', fields : [NAME,PHONE,WEBSITE]}) 
    accountList;
    /* 
    accountList.data = 
    {
    "apiName": "Account",
    "childRelationships": {},
    "fields": {
        "Name": {
            "displayValue": null,
            "value": "Zytrax Bulk CompanybatchChange"
        }
    },
    "id": "0012v00003Hpi67AAB",
    "lastModifiedById": "0052v00000aIzbbAAC",
    "lastModifiedDate": "2024-07-21T07:41:12.000Z",
    "recordTypeId": "012000000000000AAA",
    "recordTypeInfo": null,
    "systemModstamp": "2024-07-21T07:41:12.000Z"
}
    */
    get getAccountByWireProp() {
        return JSON.stringify(this.accountList.data.fields.Phone.value);
    }
    //console.log('wire prod);
    connectedCallback() {
        this.getAcctDetails();
    }
    getAcctDetails() {
        if(this.bypassImperative) {
            return;
        }
        console.log('Imperative');
        getAccountDetails({'recordId' : this.recordId})
        .then(result => {
            result.forEach(element => {
                console.log('result = ' + JSON.stringify(element));
                //result = [{"Id":"0012v00003Hpi67AAB","Name":"Zytrax Bulk CompanybatchChange","Phone":"999"}]
                let account = {}
                account.id = element.Id;
                account.name = element.Name;
                account.phone = element.Phone;
                account.website = element.Name;
                this.accountDetails.push(account)
            })
        })
        .catch(error => {
            console.log('Error');
        });
    }
    @wire(getRecord, {recordId : '$recordId', fields : [NAME,PHONE,WEBSITE]})
    accountDetail({error, data}) {
        console.log('wire function');
        if(this.bypassWireFunction) {
            return;
        }
        if(data) {
            data.forEach(element => {
                let account = {}
                account.id = element.Id;
                account.name = element.Name;
                account.phone = element.Phone;
                account.website = element.Name;
                this.accountDetails.push(account)
            })
        }
    }

        
    //console.log('accountList=='+JSON.stringify(this.accountList.data));
    
    // if(this.accountList?.data) {
    //     if(bypassWireProperty) {
    //         return;
    //     }
    //     accountList.data.forEach(element => {
    //         let account = {}
    //         account.id = element.Id;
    //         account.name = element.Name;
    //         account.phone = element.Phone;
    //         account.website = element.Name;
    //         this.accountDetails.push(account)
    //     })
    // }


    handleChange(event) {
        if(event?.detail?.value) {
            this.radioButtonValue = event?.detail?.value
            if(this.radioButtonValue == 'WFun') {
                this.bypassWireFunction = true;
                this.bypassWireProperty = false;
                this.bypassImperative = false;
            }
            else if(this.radioButtonValue == 'WProp') {
                this.bypassWireFunction = true;
                this.bypassWireProperty = false;
                this.bypassImperative = false;
            }
            else if(this.radioButtonValue == 'Imperative') {
                this.bypassWireFunction = false;
                this.bypassWireProperty = false;
                this.bypassImperative = true;
            }
        }
    }
}