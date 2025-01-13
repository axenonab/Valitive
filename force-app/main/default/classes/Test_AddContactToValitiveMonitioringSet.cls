@IsTest
private class Test_AddContactToValitiveMonitioringSet {

    private static MockValitivePropertiesProvider mockProvider = createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);
    
    @IsTest
    static void should_add_contact_to_valitive_monitoring_set() {
        // Given
        String legalId = '19910101-7890';
        Contact contact = new Contact();
        contact.FirstName = 'John';
        contact.LastName = 'Doe';
        contact.Personal_Identity_Number__c = legalId;
        insert contact;

        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        AddContactToValitiveMonitioringSetBatch batch = new AddContactToValitiveMonitioringSetBatch();
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();

        Contact updatedContact = [SELECT IsInMonitoringSet__c FROM Contact WHERE Id = :contact.Id];
        System.assertEquals(true, updatedContact.IsInMonitoringSet__c);
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