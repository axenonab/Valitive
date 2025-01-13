public class AddContactToValitiveMonitioringSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    @TestVisible
    private ValitiveService valitiveService = new ValitiveService();

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

        for (Contact contact : contacts) {
            HttpResponse response = this.valitiveService.addPersonToPrivateMonitoringSet(removeHyphen(contact.Personal_Identity_Number__c));
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