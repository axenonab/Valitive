@IsTest
private class Test_ValitiveEventsSyncQueueable {

    private static MockValitivePropertiesProvider mockProvider = createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);

    @IsTest
    static void should_sync_events() {

        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        ValitiveEventsSyncQueueable queueable = new ValitiveEventsSyncQueueable('Private');
        queueable.service.setMockIValitivePropertiesProvider(mockProvider);
        System.enqueueJob(queueable);
        Test.stopTest();
    }


    public static MockValitivePropertiesProvider createMockProvider(){
        return new MockValitivePropertiesProvider()
            .withBaseURL('https://mock.valitive.com')
            .withApiVersion('v1')
            .withTokenEndpoint('https://mock.valitive.com/oauth/token')
            .withGrantType('mock-grant')
            .withUsername('mock-user')
            .withPassword('mock-pass')
            .withPrivateMonitoringSetId('mock-private-id')
            .withOrganisationMonitoringSetId('mock-organisation-id')
            .withClientId('mock-client-id')
            .withClientSecret('mock-client-secret');
    }
}