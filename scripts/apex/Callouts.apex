Http http = new Http();
Httprequest request = new HttpRequest();
request.setEndpoint('https://gorest.co.in/public/v2/users');
request.setMethod('GET');
HttpResponse response  = http.send(request);
if(response.getStatusCode() == 200) {
    system.debug('response1='+response);
    List<UserWrapper> responseBody = (List<UserWrapper>) JSON.deserialize(response.getBody(),List<UserWrapper>.class);
    Integer userCount = 0;
    for(UserWrapper mp : responseBody) {
        system.debug('User # ='+ ++userCount);
        system.debug('User Id ='+ mp.id);
        system.debug('User Name ='+ mp.name);
    }
}
else {
    system.debug('response3='+response.getStatusCode());
}
// Fetch the callout limits
System.debug('Number of callouts made in this transaction: ' + Limits.getCallouts());
System.debug('Maximum number of callouts allowed in this transaction: ' + Limits.getLimitCallouts());
// Fetch the daily callout limits
public class UserWrapper  {
    public String ID;
    public String NAME;
    public String EMAIL;
    public String GENDER;
    public String STATUS;
}