@IsTest
private class Test_AddContactToValitiveMonitioringSet {

    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);
    
    @IsTest
    static void should_add_contact_to_valitive_monitoring_set() {
        // Given
        String legalId = '19910101-7890';
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        contact.Personal_Identity_Number__c = legalId;
        contact.IsInMonitoringSet__c = false;
        insert contact;
        mock.buildMockServer();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();

        Database.executeBatch(new AddContactToValitiveMonitioringSetBatch());
        Test.stopTest();

        Contact updatedContact = [SELECT IsInMonitoringSet__c FROM Contact WHERE Id = :contact.Id];
    }

    @isTest
    static void should_run_AddContactToValitiveMonitioringSetSch() {
        Test.startTest();
        String cronExpression = '0 0 0 * * ?';
        AddContactToValitiveMonitioringSetSch schedulable = new AddContactToValitiveMonitioringSetSch();
        String jobId = System.schedule('Test Job', cronExpression, schedulable);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(cronExpression, ct.CronExpression);
        Test.stopTest();
    }


}