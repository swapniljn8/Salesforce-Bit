# Salesforce Bit

Connecting the dots with Salesforce expertise.

## Topics

## 1. Salesforce to Salesforce integration:
- Source Org:
    - Auth Provider - Client secret and client key of the connected app. Give us the Callback URL to hit from Target org for response. 
    - Named Credential - URL to which request need to be send.
    - Apex class for making callouts. 
        - Class Name : [AccountPullCallout](force-app\main\default\classes\AccountPullCallout.cls)
    
- Target org :
    - Connected App : Gives the client secret and client key.
    - Rest API apex class to handle the HTTP requests (GET, POST, DELETE, PUT, PATCH)
        - Class Name : [RestAccountAPIservice](force-app\main\default\classes\RestAccountAPIservice.cls)

