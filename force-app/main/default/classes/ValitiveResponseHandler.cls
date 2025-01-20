public class ValitiveResponseHandler {
    

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
                Valitive_Event__c valitiveEvent = createBasicInfoEvent(event); 
                valitiveEvent = ValitiveEventHandler.handleEvent(valitiveEvent, eventPayload);
                if (valitiveEvent != null) {
                    eventsToInsert.add(valitiveEvent);
                }
            }
        if(!eventsToInsert.isEmpty()){
            upsert eventsToInsert Event_Id__c;
            setContactId(eventsToInsert);
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

    public static Valitive_Event__c createBasicInfoEvent(ValitiveEventResponse.Event event){
        Valitive_Event__c valitiveEvent = new Valitive_Event__c();
        valitiveEvent.Event_Id__c = event.id;
        valitiveEvent.Detected_At__c = event.detectedAt;
        ValitiveEvent.Person_Legal_Id__c = event.subjectIds[0];
        return valitiveEvent;
    }

}