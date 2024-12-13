//https://apidoc.valitive.com/v1/?urls.primaryName=Valitive%20API#/Monitoring/getEventsForMonitoringSet

public class ValitiveServices {

    private final ValitiveClient client;

    public ValitiveServices(ValitiveClient client) {
        this.client = client;
    }

    public HttpResponse addPersonToMonitorSet(String personId, String monitorSetId) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/se/person/{3}';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId, 
            personId
        });
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        return this.client.send(request);
    }

    public HttpResponse deletePersonsFromMonitorSet(String monitorSetId, List<String> personIds) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId 
        });
        request.setBody(JSON.serialize(new Map<String, Object>{
            'legalIds' => personIds,
            'monitoringSetIds' => new List<String>{monitorSetId}
            })
        );
        request.setMethod('DELETE');
        return this.client.send(request);
    }

    public HttpResponse deletePersonFromMonitorSet(String monitorSetId, String personId) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(),
            this.client.PROPERTIES_PROVIDER.getApiVersion(), 
            monitorSetId 
        });
        request.setBody(JSON.serialize(new Map<String, Object>{
            'legalIds' => new List<String>{personId},
            'monitoringSetIds' => new List<String>{monitorSetId}
            })
        );
        request.setMethod('DELETE');
        return this.client.send(request);
    }

    public HttpResponse getEvents(String monitorSetId, Map<String, Object> params) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/pub/api/{1}/monitoring-set/{2}/events';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            this.client.PROPERTIES_PROVIDER.getApiVersion(),
            monitorSetId
        });
        if (params != null) {
            url += '?' + generateQueryParamString(params);
        }
        request.setEndpoint(url);
        request.setMethod('GET');
        return this.client.send(request);
    }

    public String generateQueryParamString(Map<String, Object> params) {
        List<String> queryParamList = new List<String>();
    
        for (String key : params.keySet()) {
            String encodedKey = EncodingUtil.urlEncode(key, 'UTF-8');
            String encodedValue = EncodingUtil.urlEncode(String.valueOf(params.get(key)), 'UTF-8');
            queryParamList.add(encodedKey + '=' + encodedValue);
        }
    
        return String.join(queryParamList, '&');
    }

   
    
}