@IsTest
private class Test_SyncContactValitiveState {


    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);
    
    @TestSetup
    static void makeData(){
        insert new List<Contact>{
            new Contact(
                LastName = 'Test',
                Personal_Identity_Number__c = 'mock-id',
                IsInMonitoringSet__c = true
            ),
            new Contact(
                LastName = 'Test',
                Personal_Identity_Number__c = 'mock-id2',
                IsInMonitoringSet__c = true
            )
        };
    }

    @IsTest
    static void should_sync_contact_valitive_state_test(){
        mock.buildMockServer();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        SyncContactValitiveStateBatch batch = new SyncContactValitiveStateBatch();
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contact> contacts = [
            SELECT 
                Personal_Identity_Number__c, 
                MailingStreet,
                MailingCity,
                MailingRegion__c, 
                MailingPostalCode,
                MailingMunicipality__c
            FROM Contact
            WHERE IsInMonitoringSet__c = true
        ];
        System.assertEquals(2, contacts.size());
        for(Contact contact : contacts){
            System.assertEquals('mock-street mock-number mock-number-suffix lgh mock-flat', contact.MailingStreet);
            System.assertEquals('MOCK-CITY', contact.MailingCity);
            System.assertEquals('mock-county', contact.MailingRegion__c);
            System.assertEquals('mock-zip-code', contact.MailingPostalCode);
            System.assertEquals('mock-municipality', contact.MailingMunicipality__c);
        }
    }

    @IsTest
    static void should_sync_contact_valitive_state_protected_id_test(){
        mock.setNoNameQueryScopeResponse(true);
        mock.buildMockServer();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        SyncContactValitiveStateBatch batch = new SyncContactValitiveStateBatch();
        batch.valitiveService.setMockIValitivePropertiesProvider(mockProvider);
        Database.executeBatch(batch);
        Test.stopTest();
        List<Contact> contacts = [
            SELECT 
                Personal_Identity_Number__c, 
                MailingStreet,
                MailingCity,
                MailingRegion__c, 
                MailingPostalCode,
                MailingMunicipality__c
            FROM Contact
            WHERE IsInMonitoringSet__c = true
        ];
    }
}