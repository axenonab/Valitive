@IsTest
private class Test_ValitiveQuerySubjectsBatch {

    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);


    @IsTest
    static void should_get_account_from_client(){
        mock.buildMockServer();
        mock.addOrgQueryResponse();
        mock.addImportRequestPresponse();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        Account account = new Account(
            Name = 'Test Account',
            Valitive_Import_Process_Id__c = '12345',
            Valitive_Import_Process_Status__c = 'Awaiting Initial Sync',
            IsInMonitoringSet__c = true,
            Company_Number__c = '9947009438'
        );
        insert account;
        ValitiveQuerySubjectsBatch batch = new ValitiveQuerySubjectsBatch('Awaiting Initial Sync');
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();
    }

    @isTest
    static void should_run_ValitiveQuerySubjectsSch() {
        mock.buildMockServer();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        String cronExpression = '0 0 0 * * ?';
        ValitiveQuerySubjectsSch schedulable = new ValitiveQuerySubjectsSch();
        String jobId = System.schedule('Test Job', cronExpression, schedulable);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpression, ct.CronExpression);
        Test.stopTest();
    }
}