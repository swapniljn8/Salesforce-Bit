public class AccountPullCallout {
    public static void sendAccounts (List<Account> accountJSON) {
        String requestBody = JSON.serialize (accountJSON);
        String targetEndpoint = 'callout:Salesforce_Target_Org_connect/services/apexrest/Account'; // Replace with your target org's endpoint
        
        HttpRequest req = new HttpRequest () ;
        req.setEndpoint (targetEndpoint);
        req.setMethod ('POST') ;
        req.setHeader ('Authorization', 'Bearer ' + UserInfo.getSessionId () ) ; // Use a valid access token
        req.setHeader ('Content-Type' , 'application/json') ;
        system.debug ('accountsJson ==== >'+requestBody) ;
        req.setBody (requestBody);
        system.debug('endpoint=='+req.getEndpoint());
        // To fetch the response from the Source
        Http http = new Http();
        HttpResponse res = http.send (req) ;
        
        if (res.getStatusCode () != 200) {
            System.debug ('Error sending accounts: ' + res) ;
        } else {
            System.debug ('Accounts sent successfully. '+res.getBody() );
        }
    }
    public static void getAccounts() {
        String targetEndpoint = 'callout:Salesforce_Target_Org_connect/services/apexrest/Account'; // Replace with your target org's endpoint
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(targetEndpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer '+UserInfo.getSessionId());
        req.setHeader('Content-Type','application/json');
        system.debug('endpoint=='+req.getEndpoint());
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('response=get='+res.getBody());
        System.debug('StatusCode ====> '+res.getStatusCode());
    }
}