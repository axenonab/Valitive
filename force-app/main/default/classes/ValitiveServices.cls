public class ValitiveServices {

    private final ValitiveClient client;

    public ValitiveServices(ValitiveClient client) {
        this.client = client;
    }

    public HttpResponse addPersonToMonitorSet(String personId, String monitorSetId) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/monitoring-set/{1}/scope/se/person/{2}';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
            monitorSetId, 
            personId
        });
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        return this.client.send(request);
    }

    public HttpResponse deletePersonsFromMonitorSet(String monitorSetId, List<String> personIds) {
        HttpRequest request = new HttpRequest();
        String template_url = '{0}/monitoring-set/{1}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
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
        String template_url = '{0}/monitoring-set/{1}/scope/';
        String url = String.format(template_url, new List<String>{
            this.client.PROPERTIES_PROVIDER.getBaseUrl(), 
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
    
    


}