//https://apidoc.valitive.com/v1/?urls.primaryName=Valitive%20API#/Monitoring/getEventsForMonitoringSet

public class ValitiveService {


    private IValitivePropertiesProvider IPROPERTIES_PROVIDER = new ValitivePropertiesProvider();
    private ValitiveClient client = new ValitiveClient(IPROPERTIES_PROVIDER);

    @TestVisible
    private void setMockIValitivePropertiesProvider(IValitivePropertiesProvider provider) {
        this.IPROPERTIES_PROVIDER = provider;
        this.client = new ValitiveClient(provider);
    }


    /**
     * Create an HttpRequest object
     * @param method The HTTP method to use
     * @param url The URL to send the request to
     * @param body The body of the request
     * @return HttpRequest The HttpRequest object
     */
    private HttpRequest createHttpRequest(String method, String url, String body) {
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(url);
        request.setHeader('Content-Type', 'application/json');
        if(body != null){
            request.setBody(body);
        }
        return request;
    }


    /**
     * Add a person to a monitoring set
     * @param monitorSetId The ID of the monitoring set
     * @param personId The legal ID of the person to add
     * @return HttpResponse The response from the API
     */
    private HttpResponse addPersonToMonitorSet(String monitorSetId, String personId) {
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/se/person/legalId';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId
        });

        String body = JSON.serialize(new Map<String, Object>{
            'legalId' => personId
        });

        HttpRequest request = createHttpRequest('POST', url, body);
        return this.client.send(request);
    }

    public HttpResponse addPersonToPrivateMonitoringSet(String personId) {
        return addPersonToMonitorSet(this.client.PROPERTIES_PROVIDER.getPrivateMonitoringSetId(), personId);
    }

    public HttpResponse addPersonToOrganisationMonitoringSet(String personId) {
        return addPersonToMonitorSet(this.client.PROPERTIES_PROVIDER.getOrganisationMonitoringSetId(), personId);
    }

    /**
     * Add multiple persons to a monitoring set
     * @param monitorSetId The ID of the monitoring set
     * @param personIds The legal IDs of the persons to add
     * @return HttpResponse The response from the API
     */
    public HttpResponse deletePersonsFromMonitorSet(String monitorSetId, List<String> personIds) {
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId 
        });
        String body = JSON.serialize(new Map<String, Object>{
            'legalIds' => personIds,
            'monitoringSetIds' => new List<String>{monitorSetId}
            }
        );
        
        HttpRequest request = createHttpRequest('DELETE', url, body);
        return this.client.send(request);
    }


    /**
     * Delete a person from a monitoring set
     * @param monitorSetId The ID of the monitoring set
     * @param personId The legal ID of the person to delete
     */
    public HttpResponse deletePersonFromMonitorSet(String monitorSetId, String personId) {

        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(),
            this.client.PROPERTIES_PROVIDER.getApiVersion(), 
            monitorSetId
        });
        String body = JSON.serialize(new Map<String, Object>{
            'legalIds' => new List<String>{personId},
            'monitoringSetIds' => new List<String>{monitorSetId}
            }
        );
        HttpRequest request = createHttpRequest('DELETE', url, body);
        return this.client.send(request);
    }

    /**
     * Get events from Valitive API
     * @param monitorSetId The ID of the monitoring set
     * @param params The parameters to include in the request
     * @return HttpResponse The response from the API
     */
    public HttpResponse getEvents(String monitorSetId, Map<String, Object> params) {
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/events';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId
        });
        if (params != null) {
            url += '?' + generateQueryParamString(params);
        }
        HttpRequest request = createHttpRequest('GET', url, null);
        return this.client.send(request);
    }

    /**
     * Generate a query parameter string from a map
     * @param params The map of parameters
     * @return String The query parameter string
     */
    private String generateQueryParamString(Map<String, Object> params) {
        List<String> queryParamList = new List<String>();
    
        for (String key : params.keySet()) {
            String encodedKey = EncodingUtil.urlEncode(key, 'UTF-8');
            String encodedValue = EncodingUtil.urlEncode(String.valueOf(params.get(key)), 'UTF-8');
            queryParamList.add(encodedKey + '=' + encodedValue);
        }
    
        return String.join(queryParamList, '&');
    }

    /**
     * Sync events from Valitive API
     * @param url The URL to sync events from, typically from the Next-Link header
     * @return HttpResponse The response from the API
     */
    public HttpResponse syncEvents(String url){
        HttpRequest request = createHttpRequest('GET', url, null);
        HttpResponse response = this.client.send(request);
        return response;
    }

    /**
     * Sync events from Valitive API
     * @param entity The entity to sync events for
     * @param params The parameters to include in the request
     * @return HttpResponse The response from the API
     */
    public HttpResponse syncEvents(String entity, Map<String, Object> params){
        HttpResponse response;
        if(entity == 'Private'){
            response = getEvents(
                this.client.PROPERTIES_PROVIDER.getPrivateMonitoringSetId(),
                params    
            );
        } else if(entity == 'Organisation'){
            response = getEvents(
                this.client.PROPERTIES_PROVIDER.getOrganisationMonitoringSetId(),
                params    
            );
        }
        if(response.getStatusCode() == 200){
            ValitiveResponseHandler.handleEventsResponse(response);
        } else {

        }
        return response;
    }

    /**
     * Check if the response has a next page
     * @param response The response to check
     * @return Boolean True if the response has a next page
     */
    public Boolean hasNextPage(HttpResponse response) {
        return response.getHeaderKeys().contains('Next-Link');
    }


    /**
     * Check if the response has a previous page
     * @param response The response to check
     * @return Boolean True if the response has a previous page
     */
    public Boolean hasPreviousPage(HttpResponse response) {
        return response.getHeaderKeys().contains('Prev-Link');
    }

    /**
     * Get the current page from the response
     * @param response The response to get the current page from
     * @return String The current page URL
     */
    public String getCurrentPage(HttpResponse response) {
        return response.getHeader('Current-Link');
    }

    /**
     * Get the next page from the response
     * @param response The response to get the next page from
     * @return String The next page URL
     */
    public String getNextPage(HttpResponse response) {
        return response.getHeader('Next-Link');
    }

    /**
     * Get the previous page from the response
     * @param response The response to get the previous page from
     * @return String The previous page URL
     */
    public String getPreviousPage(HttpResponse response) {
        return response.getHeader('Prev-Link');
    }

    /**
     * Get the total count from the response
     * @param response The response to get the total count from
     * @return Integer The total count
     */
    public Integer getTotalCount(HttpResponse response) {
        return Integer.valueOf(response.getHeader('Total-Count'));
    }

    /**
     * Get the result count from the response
     * @param response The response to get the result count from
     * @return Integer The result count
     */
    public Integer getResultCount(HttpResponse response) {
        return Integer.valueOf(response.getHeader('Result-Count'));
    }

    /**
     * Get the result range from the response
     * @param response The response to get the result range from
     * @return String The result range
     */
    public String getResultRange(HttpResponse response) {
        return response.getHeader('Result-Range');
    }

   
    
}