public class ValitiveClient {
    
    public final IValitivePropertiesProvider PROPERTIES_PROVIDER;
    private static String access_token;

    public ValitiveClient(IValitivePropertiesProvider provider) {
        this.PROPERTIES_PROVIDER = provider;
    }


    /**
     * Fetches the access token from the cache
     * @return String The access token
     */
    public String fetchAccessToken() {
        Cache.OrgPartition partition = Cache.Org.getPartition('local.AccessTokenCache');
        String accessToken = (String) partition.get('ValitiveAuthToken');
        return accessToken;
    }

    /**
     * Gets the access token from the cache or fetches a new one
     * @return String The access token
     */
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


    /**
     * Sets the access token in the cache
     * @param accessToken The access token
     * @param expiresIn The time in seconds until the token expires
     */
    public void setAccessToken(String accessToken, Integer expiresIn) {
        Cache.OrgPartition partition = Cache.Org.getPartition('local.AccessTokenCache');
        partition.put('ValitiveAuthToken', accessToken, expiresIn);
    }

    /**
     * Generates a basic auth string
     */
    public String generateBasicAuth() {
        Blob headerValue = Blob.valueOf(this.PROPERTIES_PROVIDER.getClientId() + ':' + this.PROPERTIES_PROVIDER.getClientSecret());
        return EncodingUtil.base64Encode(headerValue);
    }

    /**
     * Gets a new access token from the Valitive API
     * @return HttpResponse The response from the API
     * @throws ValitiveAuthException If the request fails
     */
    public HttpResponse getNewAccessToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.PROPERTIES_PROVIDER.getTokenEndpoint());
        request.setHeader('Authorization', 'Basic ' + generateBasicAuth()); 
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('grant_type=' + this.PROPERTIES_PROVIDER.getGrantType() + '&username=' + this.PROPERTIES_PROVIDER.getUsername() + '&password=' + this.PROPERTIES_PROVIDER.getPassword()); 
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            throw new ValitiveAuthException('Error getting access token: ' + response.getBody());
        }
        return response;
    }


    /**
     * Sends an HTTP request with the access token
     * @param request The request to send
     * @return HttpResponse The response from the API
     */
    public HttpResponse send(HttpRequest request) {
        Http http = new Http();
        request.setHeader('Authorization', 'Bearer ' + getAccessToken());
        request.setTimeout(120000);
        return http.send(request);
    }

    public class ValitiveAuthException extends Exception{}

}