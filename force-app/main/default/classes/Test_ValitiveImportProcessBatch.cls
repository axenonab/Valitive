@IsTest
private class Test_ValitiveImportProcessBatch {


    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);

    @TestSetup
    static void makeData(){
        Account account = new Account(
            Name = 'Test Account',
            Valitive_Import_Process_Id__c = '12345',
            Valitive_Import_Process_Status__c = 'Pending',
            IsInMonitoringSet__c = true
        );
        insert account;
    }

    @IsTest
    static void should_get_account_from_client(){
        mock.buildMockServer();
        mock.addImportProcessStatusRequestMock('12345');
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        ValitiveImportProcessBatch batch = new ValitiveImportProcessBatch();
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();
        Account account = [SELECT Id, Valitive_Import_Process_Status__c FROM Account WHERE Valitive_Import_Process_Id__c = '12345' LIMIT 1];
        System.assertEquals('Awaiting Initial Sync', account.Valitive_Import_Process_Status__c);
    }

    @isTest
    static void should_run_ValitiveImportProcessSch() {
        mock.buildMockServer();
        mock.addImportProcessStatusRequestMock('12345');
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        String cronExpression = '0 0 0 * * ?';
        ValitiveImportProcessSch schedulable = new ValitiveImportProcessSch();
        String jobId = System.schedule('Test Job', cronExpression, schedulable);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpression, ct.CronExpression);
        Test.stopTest();
    }
}