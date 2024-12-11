@IsTest
private class Test_ValitiveServices {



    

    @IsTest
    static void test(){
        MockValitivePropertiesProvider mockProvider = new MockValitivePropertiesProvider()
            .withBaseURL('https://mock.valitive.com')
            .withTokenEndpoint('/mock-token')
            .withGrantType('mock-grant')
            .withUsername('mock-user')
            .withPassword('mock-pass')
            .withPrivateMonitoringSetId('mock-private-id')
            .withOrganisationMonitoringSetId('mock-organisation-id');
        ValitiveClient client = new ValitiveClient(mockProvider);
        ValitiveServices service = new ValitiveServices(client);
        HttpResponse response = service.addPersonToMonitorSet('1', '2');
    }

  
}