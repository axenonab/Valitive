public class ValitiveEventsSync {
    
    
    private static ValitivePropertiesProvider PROPERTIES_PROVIDER = new ValitivePropertiesProvider();
    private static ValitiveClient CLIENT = new ValitiveClient(PROPERTIES_PROVIDER);

    @TestVisible
    private static ValitiveServices SERVICES = new ValitiveServices(CLIENT);


    public static HttpResponse syncEvents(String entity, Map<String, Object> params){
        HttpResponse response;
        if(entity == 'Private'){
            response = SERVICES.getEvents(
                CLIENT.PROPERTIES_PROVIDER.getPrivateMonitoringSetId(),
                params    
            );
        } else if(entity == 'Organisation'){
            response = SERVICES.getEvents(
                CLIENT.PROPERTIES_PROVIDER.getOrganisationMonitoringSetId(),
                params    
            );
        }
        if(response.getStatusCode() == 200){
            // ValitiveResponseHandler.handleEventsResponse(response);
        }
        return response;
    }
}   

    