@IsTest
private class Test_ValitiveMonitoringEventTrigger {

    private static MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
    private static ValitiveClientMock mock = new ValitiveClientMock(mockProvider);

    private static String contactLegalId = '19910101-0000';

    
    @IsTest
    static void should_create_valitive_monitoring_event_when_contact_is_created(){
        mock.buildMockServer();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = contactLegalId,
            IsInMonitoringSet__c = true
        );
        insert contact;
        Test.stopTest();
        contact = [
            SELECT 
                FirstName, 
                LastName,
                MailingStreet,
                MailingCity,
                MailingRegion__c,
                MailingPostalCode,
                MailingMunicipality__c
            FROM Contact WHERE Id = :contact.Id
        ];
    }

    @IsTest
    static void should_create_valitive_monitoring_event_when_account_is_created(){
        mock.buildMockServer();
        mock.addImportRequestPresponse();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);
        Test.startTest();
        Account account = new Account(
            Name = 'Test Account',
            Company_Number__c = '5561234567',
            IsInMonitoringSet__c = true
        );
        insert account;
        Test.stopTest();
        account = [
            SELECT 
                Id,
                Valitive_Import_Process_Status__c
            FROM Account WHERE Id = :account.Id
        ];
    }

}