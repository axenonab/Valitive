@IsTest
private class Test_ValitiveEventsSyncQueueable {

    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
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
}