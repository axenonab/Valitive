public class AddContactToValitiveMonitioringSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    @TestVisible
    private ValitiveUtils valitiveUtils = new ValitiveUtils();

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Personal_Identity_Number__c
            FROM Contact
            WHERE IsInMonitoringSet__c = false
            AND Personal_Identity_Number__c != null
            AND Exclude_From_Monitoring_Set__c = false
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {

        List<ValitiveMonitoring_Event__e> events = new List<ValitiveMonitoring_Event__e>();
        for (Contact contact : contacts) {
            ValitiveMonitoring_Event__e event = new ValitiveMonitoring_Event__e();
            event.Legal_Id__c = contact.Personal_Identity_Number__c;
            event.Record_Id__c = contact.Id;
            event.Action__c = 'AddPerson';
            events.add(event);
        }
        if(!events.isEmpty()) {
            EventBus.publish(events);
        }
    }

    public void finish(Database.BatchableContext BC) {
    }

}