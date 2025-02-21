

public class ContactValitiveEventSyncBatch implements Database.Batchable<sObject> {


    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT
                Id,
                Contact__c,
                Given_Name__c,
                FirstName__c,
                LastName__c,
                Type__c,
                Phone_Kind__c,
                Telephone_Number__c,
                Country_Code__c,
                City__c,
                County__c,
                Zip__c,
                Street__c,
                Property_Identifier__c,
                Flat__c,
                Number_Suffix__c,
                Municipality__c,
                Address_Kind__c,
                Guarded_Since__c,
                Deceased_On__c,
                Sync_Status__c,
                Synced_To_Contact_At__c,
                Contact_Sync_Errors__c
            FROM Valitive_Event__c
            WHERE Sync_Status__c = 'Awaiting Contact Sync'
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Valitive_Event__c> events) {
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, List<Valitive_Event__c>> contactEventsMap = mapEventsToContactIds(events);
        for(Id contactId: contactEventsMap.keySet()){
            List<Valitive_Event__c> contactEvents = contactEventsMap.get(contactId);
            Contact updatedContact = handleContactEvents(contactId, contactEvents);
            contactsToUpdate.add(updatedContact);
        }
        doUpdate(contactsToUpdate, contactEventsMap);
    }

    public void finish(Database.BatchableContext BC) {

    }

    public void doUpdate(List<Contact> contactsToUpdate, Map<Id, List<Valitive_Event__c>> contactMap) {
        
        if(contactsToUpdate.isEmpty()){
            return;
        }
        
        List<Valitive_Event__c> eventsToUpdate = new List<Valitive_Event__c>();
        List<Database.SaveResult> saveResults = Database.update(contactsToUpdate, false);
        for(Database.SaveResult saveResult: saveResults){
            if(saveResult.isSuccess()){
                List<Valitive_Event__c> events = contactMap.get(saveResult.getId());
                for(Valitive_Event__c event: events){
                    eventsToUpdate.add(setSyncStatus(event, 'Completed', Datetime.now(), new List<Database.Error>()));
                }
            } else {
                List<Database.Error> errors = saveResult.getErrors();
                List<Valitive_Event__c> events = contactMap.get(saveResult.getId());
                for(Valitive_Event__c event: events){
                    eventsToUpdate.add(setSyncStatus(event, 'Failed', Datetime.now(), errors));
                }
            }
        }
        if(!eventsToUpdate.isEmpty()){
            update eventsToUpdate;
        }
    }

    public Valitive_event__c setSyncStatus(Valitive_event__c event, String status, Datetime syncDate, List<Database.Error> errors){
        event.Sync_Status__c = status;
        event.Synced_To_Contact_At__c = syncDate;
        if(!errors.isEmpty()){
            event.Contact_Sync_Errors__c = String.join(errors, '\n');
        }
        return event;
    }

    public Contact handleContactEvents(Id ContactId, List<Valitive_Event__c> contactEvents){
        Contact con = new Contact(Id=ContactId);
        for(Valitive_Event__c event: contactEvents){
            switch on event.Type__c {
                when 'SE_PERSON_ADDR_CHANGED' {
                    con = ContactValitiveEventMapping.mapPersonAddrChangedEventToContact(con, event);
                }
                when 'SE_PERSON_ADDR_CORRECTED' {
                    con = ContactValitiveEventMapping.PersonAddrCorrectedEventToContact(con, event);
                }
                when 'PERSON_DECEASED' {
                    con = ContactValitiveEventMapping.mapPersonDeceasedEventToContact(con, event);
                }
                when 'SE_PERSON_NAME_CHANGED' {
                    con = ContactValitiveEventMapping.mapPersonNameChangedEventToContact(con, event);
                }
                when 'PHONE_BOUND' {
                    con = ContactValitiveEventMapping.mapPhoneBoundEventToContact(con, event);
                }
                when 'PHONE_UNBOUND' {
                    //REDUNDANT
                    continue;
                }
                when 'PERSON_PROTECTION_ACTIVATED' {
                    con = ContactValitiveEventMapping.mapPersonProtectionActivatedEventToContact(con, event);
                }
                when 'PERSON_PROTECTION_DEACTIVATED' {
                    con = ContactValitiveEventMapping.mapPersonProtectionDeactivatedEventToContact(con, event);
                }
                when 'PERSON_LEGAL_ID_CHANGED' {
                    //THESE SHOULD ONLY BE FLAGGED AND NOT MAPPED TO CONTACT
                }
                when 'PERSON_GENDER_CHANGED' {
                    //THESE SHOULD ONLY BE FLAGGED AND NOT MAPPED TO CONTACT
                }
                when 'SE_GUARD_ADDED' {
                    con = ContactValitiveEventMapping.mapGuardAddedEventToContact(con, event);
                }
                when 'SE_GUARD_REMOVED' {
                    con = ContactValitiveEventMapping.mapGuardRemovedEventToContact(con, event);
                }
                when else {
                    
                }
            }
        }
        return con;
    }

    public Map<Id, List<Valitive_Event__c>> mapEventsToContactIds(List<Valitive_Event__c> events) {
        Map<Id, List<Valitive_Event__c>> contactEventsMap = new Map<Id, List<Valitive_Event__c>>();
        for(Valitive_Event__c event: events){
            Id contactId = event.Contact__c;
            if(contactEventsMap.containsKey(contactId)){
                contactEventsMap.get(contactId).add(event);
            } else {
                contactEventsMap.put(contactId, new List<Valitive_Event__c>{event});
            }
        }
        return contactEventsMap;
    }

}