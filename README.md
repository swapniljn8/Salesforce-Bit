# Salesforce Bit

Connecting the dots with Salesforce expertise.

## Topics

## 1. Salesforce to Salesforce integration:
- Source Org:
    - Auth Provider - Client secret and client key of the connected app. Give us the Callback URL to hit from Target org for response. 
    - Named Credential - URL to which request need to be send.
    - Apex class for making callouts. 
        - Class Name : [AccountPullCallout](https://github.com/swapniljn8/Salesforce-Bit/blob/4276deb9fc67f69fc1da4e45c3fc98c0e641bddc/force-app/main/default/classes/RestAccountAPIservice.cls)
    
- Target org :
    - Connected App : Gives the client secret and client key.
    - Rest API apex class to handle the HTTP requests (GET, POST, DELETE, PUT, PATCH)
        - Class Name : [RestAccountAPIservice](https://github.com/swapniljn8/Salesforce-Bit/blob/f45fd683735e70b5dfc6ae8d26e1283784da1bd0/force-app/main/default/classes/AccountPullCallout.cls)

## 2. Interview Scenarios :
1. Create a LWC component to display Account owned by current user with its Opportunity with highest amount and Primary Contact:
    - Component : [AccountContOppListView](https://github.com/swapniljn8/Salesforce-Bit/blob/main/force-app/main/default/lwc/accountContOppListView/accountContOppListView.html)
    - Controller - [AccountContOppListCtrl](https://github.com/swapniljn8/Salesforce-Bit/blob/a0a93137cee8d9f978ed29f1954cda21f97999ea/force-app/main/default/classes/AccountContOppListCtrl.cls)
2. Apex Scenarios :
    - Populate count of type field value from Contact on Account : [UpdateTypeCountOnAccount](https://github.com/swapniljn8/Salesforce-Bit/blob/1d0bf85d0844f19899bb8f554e2883be09363a1e/Scenarios/UpdateTypeCountOnAccount.apex)
