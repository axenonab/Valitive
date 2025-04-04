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
        AddContactToValitiveMonitioringSetBatch batch = new AddContactToValitiveMonitioringSetBatch();
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();

        Contact updatedContact = [SELECT IsInMonitoringSet__c FROM Contact WHERE Id = :contact.Id];
        System.assertEquals(true, updatedContact.IsInMonitoringSet__c);
    }



}