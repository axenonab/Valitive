public class AddContactToValitiveMonitioringSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {


    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Personal_Identity_Number__c,
                IsInMonitoringSet__c
            FROM Contact
            WHERE IsInMonitoringSet__c = false
            AND Personal_Identity_Number__c != null
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        ValitivePropertiesProvider provider = new ValitivePropertiesProvider();
        String privateMonitoringSetId = provider.getPrivateMonitoringSetId();

        ValitiveService valitiveService = new ValitiveService();
        for (Contact contact : contacts) {

            HttpResponse response = valitiveService.addPersonToMonitorSet(privateMonitoringSetId, removeHyphen(contact.Personal_Identity_Number__c));
            if (response.getStatusCode() < 400) {
                contact.IsInMonitoringSet__c = true;
            }
        }
        update contacts;
    }

    public void finish(Database.BatchableContext BC) {
    }

    public String removeHyphen(String ssn) {
        return ssn.replaceAll('-', '');
    }

}