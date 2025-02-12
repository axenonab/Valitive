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

    @isTest
    static void should_run_ValitiveEventsSyncSch() {
        Test.startTest();
        String cronExpression = '0 0 0 * * ?';
        ValitiveEventsSyncSch schedulable = new ValitiveEventsSyncSch();
        String jobId = System.schedule('Test Job', cronExpression, schedulable);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpression, ct.CronExpression);
        Test.stopTest();
    }
}