public class ValitiveResponseHandler {
    

    public static void handleEventsResponse(HttpResponse response){
        List<ValitiveEventResponse> eventResponse = (List<ValitiveEventResponse>) JSON.deserialize(response.getBody(), List<ValitiveEventResponse>.class);
        for(ValitiveEventResponse eventres: eventResponse){
            System.debug('Response: ' + eventres);
        }
            
        
        // if(eventResponse != null){
        //     for(ValitiveEventResponse payload : eventResponse){
        //         ValitiveEventResponse.Payload eventPayload = payload.payload;
        //         if(eventPayload instanceof ValitiveEventResponse.PhoneBoundPayload){
        //             System.debug('PhoneBoundPayload');
        //             ValitiveEventResponse.PhoneBoundPayload phoneBoundPayload = (ValitiveEventResponse.PhoneBoundPayload) eventPayload;
        //         } else if(eventPayload instanceof ValitiveEventResponse.PhoneUnboundPayload){
        //             System.debug('PhoneUnboundPayload');
        //             ValitiveEventResponse.PhoneUnboundPayload phoneUnboundPayload = (ValitiveEventResponse.PhoneUnboundPayload) eventPayload;
        //         } else if(eventPayload instanceof ValitiveEventResponse.PersonProtectionActivatedPayload){
        //             System.debug('PersonProtectionActivatedPayload');
        //             ValitiveEventResponse.PersonProtectionActivatedPayload personProtectionActivatedPayload = (ValitiveEventResponse.PersonProtectionActivatedPayload) eventPayload;
        //         } else if(eventPayload instanceof ValitiveEventResponse.PersonProtectionDeactivatedPayload){
        //             System.debug('PersonProtectionDeactivatedPayload');
        //             ValitiveEventResponse.PersonProtectionDeactivatedPayload personProtectionDeactivatedPayload = (ValitiveEventResponse.PersonProtectionDeactivatedPayload) eventPayload;
        //         } else if(eventPayload instanceof ValitiveEventResponse.PersonLegalIdChangedPayload){
        //             System.debug('PersonLegalIdChangedPayload');
        //             ValitiveEventResponse.PersonLegalIdChangedPayload personLegalIdChangedPayload = (ValitiveEventResponse.PersonLegalIdChangedPayload) eventPayload;
        //         } else if(eventPayload instanceof ValitiveEventResponse.PersonGenderChangedPayload){
        //             System.debug('PersonGenderChangedPayload');
        //             ValitiveEventResponse.PersonGenderChangedPayload personGenderChangedPayload = (ValitiveEventResponse.PersonGenderChangedPayload) eventPayload;
        //         }
        //     }
        // }
    }
}