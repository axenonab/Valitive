public class ValitiveResponseHandler {
    

    public static void handleEventsResponse(HttpResponse response){
        ValitiveEventResponse eventResponse = ValitiveEventResponse.parse(response.getBody());

        if (eventResponse == null) {
            return;
        }

        List<Valitive_Event__c> eventsToInsert = new List<Valitive_Event__c>();

        for(ValitiveEventResponse.Event event : eventResponse.events){

                ValitiveEventResponse.Payload eventPayload = event.payload;
                Valitive_Event__c valitiveEvent = createBasicInfoEvent(event);

                if(eventPayload instanceof ValitiveEventResponse.PhoneBoundPayload){

                    ValitiveEventResponse.PhoneBoundPayload phoneBoundPayload = (ValitiveEventResponse.PhoneBoundPayload) eventPayload;
                    eventsToInsert.add(createPhoneBoundEvent(valitiveEvent, phoneBoundPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PhoneUnboundPayload){

                    ValitiveEventResponse.PhoneUnboundPayload phoneUnboundPayload = (ValitiveEventResponse.PhoneUnboundPayload) eventPayload;
                    eventsToInsert.add(createPhoneUnboundEvent(valitiveEvent, phoneUnboundPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonProtectionActivatedPayload){

                    ValitiveEventResponse.PersonProtectionActivatedPayload personProtectionActivatedPayload = (ValitiveEventResponse.PersonProtectionActivatedPayload) eventPayload;
                    eventsToInsert.add(createPersonProtectionActivatedEvent(valitiveEvent, personProtectionActivatedPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonProtectionDeactivatedPayload){

                    ValitiveEventResponse.PersonProtectionDeactivatedPayload personProtectionDeactivatedPayload = (ValitiveEventResponse.PersonProtectionDeactivatedPayload) eventPayload;
                    eventsToInsert.add(createPersonProtectionDeactivatedEvent(valitiveEvent, personProtectionDeactivatedPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonLegalIdChangedPayload){

                    ValitiveEventResponse.PersonLegalIdChangedPayload personLegalIdChangedPayload = (ValitiveEventResponse.PersonLegalIdChangedPayload) eventPayload;
                    eventsToInsert.add(createPersonLegalIdChangedEvent(valitiveEvent, personLegalIdChangedPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonGenderChangedPayload){

                    ValitiveEventResponse.PersonGenderChangedPayload personGenderChangedPayload = (ValitiveEventResponse.PersonGenderChangedPayload) eventPayload;
                    eventsToInsert.add(createPersonGenderChangedEvent(valitiveEvent, personGenderChangedPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonAddrChangedPayload){

                    ValitiveEventResponse.PersonAddrChangedPayload personAddrChangedPayload = (ValitiveEventResponse.PersonAddrChangedPayload) eventPayload;
                    Valitive_Event__c createdEvent = createPersonAddrChangedEvent(valitiveEvent, personAddrChangedPayload);
                    if(createdEvent.Address_Type__c == 'SE_NORMALIZED') {
                        eventsToInsert.add(createdEvent);
                    }

                } else if(eventPayload instanceOf ValitiveEventResponse.PersonAddrCorrectedPayload){

                    ValitiveEventResponse.PersonAddrCorrectedPayload personAddrCorrectedPayload = (ValitiveEventResponse.PersonAddrCorrectedPayload) eventPayload;
                    eventsToInsert.add(createPersonAddrCorrectedEvent(valitiveEvent, personAddrCorrectedPayload));

                } else if(eventPayload instanceof ValitiveEventResponse.PersonNameChangedPayload) {

                    ValitiveEventResponse.PersonNameChangedPayload personNameChangedPayload = (ValitiveEventResponse.PersonNameChangedPayload) eventPayload;
                    eventsToInsert.add(createPersonNameChangedEvent(valitiveEvent, personNameChangedPayload));
                }

                else if(eventPayload instanceof ValitiveEventResponse.PersonDeceasedPayload) {

                    ValitiveEventResponse.PersonDeceasedPayload personDeceasedPayload = (ValitiveEventResponse.PersonDeceasedPayload) eventPayload;
                    eventsToInsert.add(PersonDeceasedEvent(valitiveEvent, personDeceasedPayload));

                } 

                else if (eventPayload instanceof ValitiveEventResponse.PersonGuardPayload) {

                    ValitiveEventResponse.PersonGuardPayload personGuardPayload = (ValitiveEventResponse.PersonGuardPayload) eventPayload;
                    eventsToInsert.add(createPersonGuardEvent(valitiveEvent, personGuardPayload));
                }
                 else {
                    continue;
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

    public static Valitive_Event__c createPersonGuardEvent(Valitive_Event__c event, ValitiveEventResponse.PersonGuardPayload personGuardPayload){
        event.Type__c = personGuardPayload.type;
        event.Person_Id__c = personGuardPayload.personId;
        event.Timestamp__c = personGuardPayload.timestamp;
        event.Guardianship_Type__c = personGuardPayload.guardianshipInfo.type;
        event.Guarded_Since__c = personGuardPayload.guardianshipInfo.guardedSince;
        return event;
    }

    public static Valitive_Event__c createPhoneBoundEvent(Valitive_Event__c event, ValitiveEventResponse.PhoneBoundPayload phoneBoundPayload){
        event.Type__c = phoneBoundPayload.type;
        event.Person_Id__c = phoneBoundPayload.partyId;
        event.Timestamp__c = phoneBoundPayload.timestamp;
        event.Phone_Kind__c = phoneBoundPayload.kind;
        event.Telephone_Number__c = phoneBoundPayload.telNumber;
        event.Country_Code__c = phoneBoundPayload.countryCode;
        event.Area_Code__c = phoneBoundPayload.areaCode;
        event.Registered_Since__c = phoneBoundPayload.registeredSince;
        event.Provider__c = phoneBoundPayload.provider;
        return event;
    }

    public static Valitive_Event__c createPhoneUnboundEvent(Valitive_Event__c event, ValitiveEventResponse.PhoneUnboundPayload phoneUnboundPayload){
        event.Type__c = phoneUnboundPayload.type;
        event.Person_Id__c = phoneUnboundPayload.partyId;
        event.Timestamp__c = phoneUnboundPayload.timestamp;
        event.Phone_Kind__c = phoneUnboundPayload.kind;
        event.Telephone_Number__c = phoneUnboundPayload.telNumber;
        event.Country_Code__c = phoneUnboundPayload.countryCode;
        event.Area_Code__c = phoneUnboundPayload.areaCode;
        event.Registered_Since__c = phoneUnboundPayload.registeredSince;
        event.Provider__c = phoneUnboundPayload.provider;
        return event;
    }

    public static Valitive_Event__c createPersonProtectionActivatedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonProtectionActivatedPayload personProtectionActivatedPayload){
        event.Type__c = personProtectionActivatedPayload.type;
        event.Since__c = personProtectionActivatedPayload.since;
        event.person_Id__c = personProtectionActivatedPayload.personId;
        event.Timestamp__c = personProtectionActivatedPayload.timestamp;
        return event;
    }

    public static Valitive_Event__c createPersonProtectionDeactivatedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonProtectionDeactivatedPayload personProtectionDeactivatedPayload){
        event.Type__c = personProtectionDeactivatedPayload.type;
        event.Since__c = personProtectionDeactivatedPayload.since;
        event.person_Id__c = personProtectionDeactivatedPayload.personId;
        event.Timestamp__c = personProtectionDeactivatedPayload.timestamp;
        return event;
    }

    public static Valitive_Event__c createPersonLegalIdChangedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonLegalIdChangedPayload personLegalIdChangedPayload){
        event.Type__c = personLegalIdChangedPayload.type;
        event.Old_Legal_Id__c = personLegalIdChangedPayload.oldLegalId;
        event.Valid_Since__c = personLegalIdChangedPayload.validSince;
        event.Old_Legal_Id__c = personLegalIdChangedPayload.oldLegalId;
        event.Person_Id__c = personLegalIdChangedPayload.personId;
        event.Timestamp__c = personLegalIdChangedPayload.timestamp;
        event.Sync_Status__c = 'Awaiting Manual Review';
        return event;
    }

    public static Valitive_Event__c PersonDeceasedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonDeceasedPayload personDeceasedPayload){
        event.Type__c = personDeceasedPayload.type;
        event.Person_Id__c = personDeceasedPayload.personId;
        event.Timestamp__c = personDeceasedPayload.timestamp;
        event.Deceased_On__c = personDeceasedPayload.deceasedOn;
        event.Deceased_On_Month__c = personDeceasedPayload.deceasedOnMonth;
        event.Deceased_On_Year__c = personDeceasedPayload.deceasedOnYear;
        return event;
    }

    public static Valitive_Event__c createPersonGenderChangedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonGenderChangedPayload personGenderChangedPayload){
        event.Type__c = personGenderChangedPayload.type;
        event.Gender__c = personGenderChangedPayload.gender;
        event.Old_Gender__c = personGenderChangedPayload.oldGender;
        event.Timestamp__c = personGenderChangedPayload.timestamp;
        event.Person_Id__c = personGenderChangedPayload.personId;
        event.Sync_Status__c = 'Awaiting Manual Review';
        return event;
    }

    public static Valitive_Event__c createPersonAddrChangedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonAddrChangedPayload personAddrChangedPayload){
        event.Type__c = personAddrChangedPayload.type;
        event.Person_Id__c = personAddrChangedPayload.personId;
        event.Timestamp__c = personAddrChangedPayload.timestamp;
        event.Valid_Since__c = personAddrChangedPayload.validSince;

        if(personAddrChangedPayload.address instanceOf ValitiveEventResponse.SwedishAddress){
            ValitiveEventResponse.SwedishAddress swedishAddress = (ValitiveEventResponse.SwedishAddress) personAddrChangedPayload.address;
            event = mapSwedishAddress(event, swedishAddress);

        } 
        //NO INTREST IN RAW ADDRESSES
        else if(personAddrChangedPayload.address instanceOf ValitiveEventResponse.RawAddress){
            //NO INTREST IN RAW ADDRESSES
            ValitiveEventResponse.RawAddress rawAddress = (ValitiveEventResponse.RawAddress) personAddrChangedPayload.address;
            event = mapRawAddress(event, rawAddress);
        }

        if(personAddrChangedPayload.oldAddress instanceOf ValitiveEventResponse.SwedishAddress){
            ValitiveEventResponse.SwedishAddress swedishAddress = (ValitiveEventResponse.SwedishAddress) personAddrChangedPayload.oldAddress;
            event = mapOldSwedishAddress(event, swedishAddress);

        } 
        //NO INTREST IN RAW ADDRESSES
        else if(personAddrChangedPayload.oldAddress instanceOf ValitiveEventResponse.RawAddress){

            ValitiveEventResponse.RawAddress rawAddress = (ValitiveEventResponse.RawAddress) personAddrChangedPayload.oldAddress;
            event = mapOldRawAddress(event, rawAddress);
        }
        return event;
    }

    public static Valitive_Event__c createPersonAddrCorrectedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonAddrCorrectedPayload personAddrCorrectedPayload){
        event.Type__c = personAddrCorrectedPayload.type;
        event.Person_Id__c = personAddrCorrectedPayload.personId;
        event.Timestamp__c = personAddrCorrectedPayload.timestamp;
        event.Valid_Since__c = personAddrCorrectedPayload.validSince;

        if(personAddrCorrectedPayload.address instanceOf ValitiveEventResponse.SwedishAddress){
            ValitiveEventResponse.SwedishAddress swedishAddress = (ValitiveEventResponse.SwedishAddress) personAddrCorrectedPayload.address;
            event = mapSwedishAddress(event, swedishAddress);
        } else if(personAddrCorrectedPayload.address instanceOf ValitiveEventResponse.RawAddress){
            ValitiveEventResponse.RawAddress rawAddress = (ValitiveEventResponse.RawAddress) personAddrCorrectedPayload.address;
            event = mapRawAddress(event, rawAddress);
        }

        if(personAddrCorrectedPayload.oldAddress instanceOf ValitiveEventResponse.SwedishAddress){
            ValitiveEventResponse.SwedishAddress swedishAddress = (ValitiveEventResponse.SwedishAddress) personAddrCorrectedPayload.oldAddress;
            event = mapOldSwedishAddress(event, swedishAddress);
        } else if(personAddrCorrectedPayload.oldAddress instanceOf ValitiveEventResponse.RawAddress){
            ValitiveEventResponse.RawAddress rawAddress = (ValitiveEventResponse.RawAddress) personAddrCorrectedPayload.oldAddress;
            event = mapOldRawAddress(event, rawAddress);
        }
        return event;
    }

    public static Valitive_Event__c createPersonNameChangedEvent(Valitive_Event__c event, ValitiveEventResponse.PersonNameChangedPayload personNameChangedPayload){
        event.Type__c = personNameChangedPayload.type;
        event.Person_Legal_Id__c = personNameChangedPayload.personLegalId;
        event.Person_Id__c = personNameChangedPayload.personId;
        event.Timestamp__c = personNameChangedPayload.timestamp;
        event.Given_Name__c = personNameChangedPayload.givenName;
        event.Old_Given_Name__c = personNameChangedPayload.oldGivenName;
        event.FirstName__c = personNameChangedPayload.firstName;
        event.Old_FirstName__c = personNameChangedPayload.oldFirstName;
        event.MiddleName__c = personNameChangedPayload.middleName;
        event.Old_MiddleName__c = personNameChangedPayload.oldMiddleName;
        event.LastName__c = personNameChangedPayload.lastName;
        event.Old_LastName__c = personNameChangedPayload.oldLastName;
        event.Valid_Since__c = personNameChangedPayload.validSince;
        return event;
    }

    private static Valitive_Event__c mapSwedishAddress(Valitive_Event__c event, ValitiveEventResponse.SwedishAddress swedishAddress){
        event.Address_Type__c = swedishAddress.type;
        event.Address_Kind__c = swedishAddress.kind;
        event.Country__c = swedishAddress.country;
        event.City__c = swedishAddress.city;
        event.Zip__c = swedishAddress.zip; 
        event.Address_Coord__Latitude__s = swedishAddress.geolocation.latitude;
        event.Address_Coord__Longitude__s = swedishAddress.geolocation.longitude;
        event.Postbox__c = swedishAddress.postbox;
        event.Street__c = swedishAddress.street;
        event.Additional_Street_Info__c = swedishAddress.street2;
        event.Property_Identifier__c = swedishAddress.streetNumber;
        event.Number_Suffix__c = swedishAddress.numberSuffix;
        event.flat__c = swedishAddress.flat;
        event.Care_Of__c = swedishAddress.careOf;
        event.County__c = swedishAddress.county;
        event.Municipality__c = swedishAddress.municipality;
        event.Misc__c = swedishAddress.misc;
        event.Floor__c = swedishAddress.floor;
        event.Entrance__c = swedishAddress.entrance;
        return event;
    }

    private static Valitive_Event__c mapRawAddress(Valitive_Event__c event, ValitiveEventResponse.RawAddress rawAddress){
        event.Address_Type__c = rawAddress.type;
        event.Country__c = rawAddress.country;
        event.Address_Lines__c = String.join(rawAddress.addressLines, '\n');
        return event;
    }

    private static Valitive_Event__c mapOldSwedishAddress(Valitive_Event__c event, ValitiveEventResponse.SwedishAddress swedishAddress){
        event.Old_Address_Type__c = swedishAddress.type;
        event.Old_Address_Kind__c = swedishAddress.kind;
        event.Old_Country__c = swedishAddress.country;
        event.Old_City__c = swedishAddress.city;
        event.Old_Zip__c = swedishAddress.zip; 
        event.Old_Address_Coord__Latitude__s = swedishAddress.geolocation.latitude;
        event.Old_Address_Coord__Longitude__s = swedishAddress.geolocation.longitude;
        event.Old_Postbox__c = swedishAddress.postbox;
        event.Old_Street__c = swedishAddress.street;
        event.Old_Additional_Street_Info__c = swedishAddress.street2;
        event.Old_Property_Identifier__c = swedishAddress.streetNumber;
        event.Old_Number_Suffix__c = swedishAddress.numberSuffix;
        event.Old_flat__c = swedishAddress.flat;
        event.Old_Care_Of__c = swedishAddress.careOf;
        event.Old_County__c = swedishAddress.county;
        event.Old_Municipality__c = swedishAddress.municipality;
        event.Old_Misc__c = swedishAddress.misc;
        event.Old_Floor__c = swedishAddress.floor;
        event.Old_Entrance__c = swedishAddress.entrance;
        event.Old_Address_Kind__c = swedishAddress.kind;
        return event;
    }

    private static Valitive_Event__c mapOldRawAddress(Valitive_Event__c event, ValitiveEventResponse.RawAddress rawAddress){
        event.Old_Address_Type__c = rawAddress.type;
        event.Old_Country__c = rawAddress.country;
        event.Old_Address_Lines__c = String.join(rawAddress.addressLines, '\n');
        return event;
    }

}