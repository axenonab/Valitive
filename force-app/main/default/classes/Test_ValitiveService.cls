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

    @IsTest
    static void should_get_valitive_provider_settings(){
        Valitive_Setting__mdt settings = new Valitive_Setting__mdt();
        settings.Base_URL__c = 'https://mock.valitive.com';
        settings.Token_Endpoint__c = '/mock/token';
        settings.Grant_Type__c = 'mock_grant_type';
        settings.Username__c = 'mock_username';
        settings.Password__c = 'mock_password';
        settings.Private_Monitoring_Set_Id__c = 'mock_private_monitoring_set_id';
        settings.Organisation_Monitoring_Set_Id__c = 'mock_organisation_monitoring_set_id';
        settings.Client_Id__c = 'mock_client_id';
        settings.Client_Secret__c = 'mock_client_secret';
        settings.API_Version__c = 'v1';
        Test.startTest();
        ValitivePropertiesProvider provider = new ValitivePropertiesProvider();
        provider.SETTINGS = settings;
        Assert.areEqual('https://mock.valitive.com', provider.getBaseUrl());
        Assert.areEqual('/mock/token', provider.getTokenEndpoint());
        Assert.areEqual('mock_grant_type', provider.getGrantType());
        Assert.areEqual('mock_username', provider.getUsername());
        Assert.areEqual('mock_password', provider.getPassword());
        Assert.areEqual('mock_private_monitoring_set_id', provider.getPrivateMonitoringSetId());
        Assert.areEqual('mock_organisation_monitoring_set_id', provider.getOrganisationMonitoringSetId());
        Assert.areEqual('mock_client_id', provider.getClientId());
        Assert.areEqual('mock_client_secret', provider.getClientSecret());
        Assert.areEqual('v1', provider.getApiVersion());
        Test.stopTest();
    }

  

}