public class ValitiveResponseHandler {
    
        private static List<Valitive_Event__c> contactEventsToUpdate = new List<Valitive_Event__c>();
        private static List<Valitive_Event__c> accountEventsToUpdate = new List<Valitive_Event__c>();

    public static void handleEventsResponse(HttpResponse response){
        ValitiveEventResponse eventResponse = ValitiveEventResponse.parse(response.getBody());

        if (eventResponse == null) {
            return;
        }

        List<Valitive_Event__c> eventsToInsert = new List<Valitive_Event__c>();
        

        for(ValitiveEventResponse.Event event : eventResponse.events){

                ValitiveEventResponse.Payload eventPayload = event.payload;
                if (eventPayload == null) {
                    continue;
                }

                Valitive_Event__c baseEvent;

                String subjectType = ValitiveEventHandler.getPayloadSubjectType(eventPayload);
                
                Valitive_Event__c valitiveEvent = createBasicInfoEvent(event, subjectType); 
                valitiveEvent = ValitiveEventHandler.handleEvent(valitiveEvent, eventPayload);

                if (valitiveEvent != null) {
                    eventsToInsert.add(valitiveEvent);
                }
            }
        if(!eventsToInsert.isEmpty()){
            upsert eventsToInsert Event_Id__c;
        }
        if(!contactEventsToUpdate.isEmpty()){
            setContactId(contactEventsToUpdate);
        }
        if(!accountEventsToUpdate.isEmpty()){
            setAccountId(accountEventsToUpdate);
        }
    }

    public static void setContactId(List<Valitive_Event__c> events){
        List<Valitive_Event__c> eventsToUpdate = new List<Valitive_Event__c>();
        for(Valitive_Event__c event : events){
            String formattedLegalId = event.Person_Legal_Id__c.subString(0, 8) + '-' + event.Person_Legal_Id__c.subString(8, 12);
            event.Contact__r = new Contact(Personal_Identity_Number__c = formattedLegalId);
            eventsToUpdate.add(event);
        }
        List<Database.SaveResult> results = Database.update(eventsToUpdate, false);
    }

    public static void setAccountId(List<Valitive_Event__c> events){
        List<Valitive_Event__c> eventsToUpdate = new List<Valitive_Event__c>();
        for(Valitive_Event__c event : events){
            String formattedCompanyNumber = event.Organization_Legal_Id__c.subString(0, 6) + '-' + event.Organization_Legal_Id__c.subString(6, 10);
            event.Account__r = new Account(Company_Number__c = formattedCompanyNumber);
            eventsToUpdate.add(event);
        }
        List<Database.SaveResult> results = Database.update(eventsToUpdate, false);
    }

    public static Valitive_Event__c createBasicInfoEvent(ValitiveEventResponse.Event event, String subjectType){
        Valitive_Event__c valitiveEvent;
        switch on subjectType {
            when 'PERSON' {
                valitiveEvent = createBasicInfoPersonEvent(event);
                contactEventsToUpdate.add(valitiveEvent);
            }
            when 'ORGANIZATION' {
                valitiveEvent = createBasicInfoOrgEvent(event);
                accountEventsToUpdate.add(valitiveEvent);
            }
            when else {
                return null;
            }
        }
        return valitiveEvent;
    }

    public static Valitive_Event__c createBasicInfoPersonEvent(ValitiveEventResponse.Event event){
        Valitive_Event__c valitiveEvent = new Valitive_Event__c();
        valitiveEvent.Event_Id__c = event.id;
        valitiveEvent.Detected_At__c = event.detectedAt;
        valitiveEvent.Person_Legal_Id__c = event.subjectIds[0];
        valitiveEvent.Event_Subject_Type__c = 'PERSON';
        valitiveEvent.Sync_Status__c = 'Awaiting Contact Sync';
        return valitiveEvent;
    }

    public static Valitive_Event__c createBasicInfoOrgEvent(ValitiveEventResponse.Event event){
        Valitive_Event__c valitiveEvent = new Valitive_Event__c();
        valitiveEvent.Event_Id__c = event.id;
        valitiveEvent.Detected_At__c = event.detectedAt;
        valitiveEvent.Organization_Legal_Id__c = event.subjectIds[0];
        valitiveEvent.Event_Subject_Type__c = 'ORGANIZATION';
        valitiveEvent.Sync_Status__c = 'Awaiting Account Sync';
        return valitiveEvent;
    }

}