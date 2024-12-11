public virtual class ValitiveClient {
    
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

    public HttpResponse getNewAccessToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/{1}?grant_type={2}&password={3}&username={4}';
        String url = String.format(template_url, new List<String>{
            this.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.PROPERTIES_PROVIDER.getTokenEndpoint(), 
            this.PROPERTIES_PROVIDER.getGrantType(), 
            this.PROPERTIES_PROVIDER.getPassword(), 
            this.PROPERTIES_PROVIDER.getUsername()
        });
        request.setEndpoint(url);
        request.setMethod('POST');    
        return http.send(request);
    }

    public HttpResponse send(HttpRequest request) {
        Http http = new Http();
        request.setHeader('Authorization', 'Bearer ' + getAccessToken());
        return http.send(request);
    }
}