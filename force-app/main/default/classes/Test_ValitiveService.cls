@IsTest
private class Test_ValitiveService {

    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);
    

    @IsTest
    static void should_add_person_to_monitorset_test(){
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        ValitiveService service = new ValitiveService();
        service.setMockIValitivePropertiesProvider(mockProvider);
        HttpResponse response = service.addPersonToPrivateMonitoringSet('1');

        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());
    }

    @IsTest
    static void should_delete_person_from_monitorset_test(){
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        ValitiveService service = new ValitiveService();
        service.setMockIValitivePropertiesProvider(mockProvider);
        HttpResponse response = service.deletePersonFromMonitorSet(mockProvider.getPrivateMonitoringSetId(), '1');

        Test.stopTest();

        System.assertEquals(204, response.getStatusCode());

    }

    @IsTest
    static void should_delete_persons_from_monitorset_test(){
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        ValitiveService service = new ValitiveService();
        service.setMockIValitivePropertiesProvider(mockProvider);
        HttpResponse response = service.deletePersonsFromMonitorSet(mockProvider.getPrivateMonitoringSetId(), new List<String>{'1', '2'});

        Test.stopTest();

        System.assertEquals(204, response.getStatusCode());

    }

    @IsTest
    static void should_get_events_from_monitorset_test(){
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        ValitiveService service = new ValitiveService();
        service.setMockIValitivePropertiesProvider(mockProvider);
        HttpResponse response = service.getEvents(mockProvider.getPrivateMonitoringSetId(), null);

        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());

    }


    @IsTest
    static void should_get_events_from_monitorset_w_params_test(){

        mock.setRequestMock(
            mockProvider.getBaseURL() + '/pub/api/' + mockProvider.getApiVersion() + '/monitoring-set/' + mockProvider.getPrivateMonitoringSetId() + '/events?eventTypes=mock-event-type', 
            new SingleRequestMock(200, 'OK', '{"mock": "response"}', new Map<String, String>{'Content-Type' => 'application/json'})
        );

        Map<String, Object> params = new Map<String, Object>{
            ValitiveQueryParams.EVENT_TYPES => 'mock-event-type'
        };

        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        ValitiveService service = new ValitiveService();
        service.setMockIValitivePropertiesProvider(mockProvider);
        HttpResponse response = service.getEvents(mockProvider.getPrivateMonitoringSetId(), params);

        Test.stopTest();

        System.assertEquals(200, response.getStatusCode());

    }

  

}