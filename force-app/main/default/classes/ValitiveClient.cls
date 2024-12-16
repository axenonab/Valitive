public class ValitiveClient {
    
    public final IValitivePropertiesProvider PROPERTIES_PROVIDER;
    private static String access_token;

    public ValitiveClient(IValitivePropertiesProvider provider) {
        this.PROPERTIES_PROVIDER = provider;
    }

    public String fetchAccessToken() {
        String accessToken = (String) Cache.Org.get('local.AccessTokenCache.ValitiveAuthToken');
        return accessToken;
    }

    public String getAccessToken() {

        String accessToken = fetchAccessToken();
        
        if (accessToken == null) {
            HttpResponse response = getNewAccessToken();
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                accessToken = (String) responseMap.get('access_token');
                Integer expiresIn = (Integer) responseMap.get('expires_in');
                setAccessToken(accessToken, expiresIn);
            }
        }
        return accessToken;
    }

    public void setAccessToken(String accessToken, Integer expiresIn) {
        Cache.Org.put('local.AccessTokenCache.ValitiveAuthToken', accessToken, expiresIn);
    }

    public String generateBasicAuth() {
        Blob headerValue = Blob.valueOf(this.PROPERTIES_PROVIDER.getClientId() + ':' + this.PROPERTIES_PROVIDER.getClientSecret());
        return EncodingUtil.base64Encode(headerValue);
    }

    public HttpResponse getNewAccessToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.PROPERTIES_PROVIDER.getTokenEndpoint());
        request.setHeader('Authorization', 'Basic ' + generateBasicAuth()); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=' + this.PROPERTIES_PROVIDER.getGrantType() + '&username=' + this.PROPERTIES_PROVIDER.getUsername() + '&password=' + this.PROPERTIES_PROVIDER.getPassword()); 
        System.debug('Request: ' + request.getBody());
        System.debug('Headers: ' + request.getHeader('Authorization'));
        System.debug('Endpoint: ' + request.getEndpoint());
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            throw new ValitiveAuthException('Error getting access token: ' + response.getBody());
        }
        return response;
    }

    public HttpResponse send(HttpRequest request) {
        Http http = new Http();
        request.setHeader('Authorization', 'Bearer ' + getAccessToken());
        return http.send(request);
    }

    public class ValitiveAuthException extends Exception{}

}