//https://apidoc.valitive.com/v1/?urls.primaryName=Valitive%20API#/Monitoring/getEventsForMonitoringSet

public class ValitiveServices {


    private IValitivePropertiesProvider IPROPERTIES_PROVIDER = new ValitivePropertiesProvider();
    private ValitiveClient client = new ValitiveClient(IPROPERTIES_PROVIDER);

    @TestVisible
    private void setMockIValitivePropertiesProvider(IValitivePropertiesProvider provider) {
        this.IPROPERTIES_PROVIDER = provider;
        this.client = new ValitiveClient(provider);
    }

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


    public HttpResponse addPersonToMonitorSet(String monitorSetId, String personId) {
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/se/person/{3}';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId, 
            personId
        });

        HttpRequest request = createHttpRequest('POST', url, null);
        return this.client.send(request);
    }

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

    private String generateQueryParamString(Map<String, Object> params) {
        List<String> queryParamList = new List<String>();
    
        for (String key : params.keySet()) {
            String encodedKey = EncodingUtil.urlEncode(key, 'UTF-8');
            String encodedValue = EncodingUtil.urlEncode(String.valueOf(params.get(key)), 'UTF-8');
            queryParamList.add(encodedKey + '=' + encodedValue);
        }
    
        return String.join(queryParamList, '&');
    }

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
        }
        return response;
    }



   
    
}