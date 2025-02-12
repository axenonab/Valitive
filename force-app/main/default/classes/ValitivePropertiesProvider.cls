

public class ValitivePropertiesProvider implements IValitivePropertiesProvider {

    @TestVisible
    private Valitive_Setting__mdt SETTINGS;

    public ValitivePropertiesProvider() {
        SETTINGS = getSettings();
    }

    public String getBaseUrl() {
        return (String) SETTINGS.get('Base_URL__c');
    }

    public String getTokenEndpoint() {
        return (String) SETTINGS.get('Token_Endpoint__c');
    }

    public String getGrantType() {
        return (String) SETTINGS.get('Grant_Type__c');
    }

    public String getUsername() {
        return (String) SETTINGS.get('Username__c');
    }

    public String getPassword() {
        return (String) SETTINGS.get('Password__c');
    }

    public String getPrivateMonitoringSetId() {
        return (String) SETTINGS.get('Private_Monitoring_Set_Id__c');
    }

    public String getOrganisationMonitoringSetId() {
        return (String) SETTINGS.get('Organisation_Monitoring_Set_Id__c');
    }

    public String getClientId() {
        return (String) SETTINGS.get('Client_Id__c');
    }

    public String getClientSecret() {
        return (String) SETTINGS.get('Client_Secret__c');
    }

    public String getApiVersion() {
        return (String) SETTINGS.get('API_Version__c');
    }

    public Valitive_Setting__mdt getSettings() {
        Boolean isSandbox = isSandbox();
        Valitive_Setting__mdt settings = isSandbox() ? Valitive_Setting__mdt.getInstance('Sandbox') : Valitive_Setting__mdt.getInstance('Production');
        return settings;
    }

    private static Boolean isSandbox() {
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        return isSandbox;
    }

}

