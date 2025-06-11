public class ValitiveEventHandler {

    public static Map<Type, IValitiveEventHandler> eventHandlers = new Map<Type, IValitiveEventHandler>{
        ValitiveEventResponse.PhoneBoundPayload.class => new PhoneBoundEvent(),
        // ValitiveEventResponse.PhoneUnboundPayload.class => new PhoneUnboundEvent(),
        ValitiveEventResponse.PersonProtectionActivatedPayload.class => new PersonProtectionActivatedEvent(),
        ValitiveEventResponse.PersonProtectionDeactivatedPayload.class => new PersonProtectionDeactivatedEvent(),
        ValitiveEventResponse.PersonLegalIdChangedPayload.class => new PersonLegalIdChangedEvent(),
        ValitiveEventResponse.PersonGenderChangedPayload.class => new PersonGenderChangedEvent(),
        ValitiveEventResponse.PersonAddrChangedPayload.class => new PersonAddrChangedEvent(),
        ValitiveEventResponse.PersonAddrCorrectedPayload.class => new PersonAddrCorrectedEvent(),
        ValitiveEventResponse.PersonNameChangedPayload.class => new PersonNameChangedEvent(),
        ValitiveEventResponse.PersonDeceasedPayload.class => new PersonDeceasedEvent(),
        ValitiveEventResponse.PersonGuardPayload.class => new PersonGuardEvent()
    };

    public static IValitiveEventHandler getEventHandler(ValitiveEventResponse.Payload payload){
        return eventHandlers.get(payload.getClassType());
    }

    public static Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
        IValitiveEventHandler handler = getEventHandler(payload);
        if(handler != null) {
            return handler.handleEvent(baseEvent, payload);
        }
        return null;
    }


    public interface IValitiveEventHandler {
        Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload);
    }
    
    public class PhoneBoundEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PhoneBoundPayload phoneBoundPayload = (ValitiveEventResponse.PhoneBoundPayload) payload;
            baseEvent.Type__c = phoneBoundPayload.type;
            baseEvent.Person_Id__c = phoneBoundPayload.partyId;
            baseEvent.Timestamp__c = phoneBoundPayload.timestamp;
            baseEvent.Phone_Kind__c = phoneBoundPayload.kind;
            baseEvent.Telephone_Number__c = phoneBoundPayload.telNumber;
            baseEvent.Country_Code__c = phoneBoundPayload.countryCode;
            baseEvent.Area_Code__c = phoneBoundPayload.areaCode;
            baseEvent.Registered_Since__c = phoneBoundPayload.registeredSince;
            baseEvent.Provider__c = phoneBoundPayload.provider;
            return baseEvent;
        }
    }

    // public class PhoneUnboundEvent implements IValitiveEventHandler {
    //     public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
    //         ValitiveEventResponse.PhoneUnboundPayload phoneUnboundPayload = (ValitiveEventResponse.PhoneUnboundPayload) payload;
    //         baseEvent.Type__c = phoneUnboundPayload.type;
    //         baseEvent.Person_Id__c = phoneUnboundPayload.partyId;
    //         baseEvent.Timestamp__c = phoneUnboundPayload.timestamp;
    //         baseEvent.Phone_Kind__c = phoneUnboundPayload.kind;
    //         baseEvent.Telephone_Number__c = phoneUnboundPayload.telNumber;
    //         baseEvent.Country_Code__c = phoneUnboundPayload.countryCode;
    //         baseEvent.Area_Code__c = phoneUnboundPayload.areaCode;
    //         baseEvent.Registered_Since__c = phoneUnboundPayload.registeredSince;
    //         baseEvent.Provider__c = phoneUnboundPayload.provider;
    //         return baseEvent;
    //     }
    // }

    public class PersonProtectionActivatedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonProtectionActivatedPayload personProtectionActivatedPayload = (ValitiveEventResponse.PersonProtectionActivatedPayload) payload;
            baseEvent.Type__c = personProtectionActivatedPayload.type;
            baseEvent.Since__c = personProtectionActivatedPayload.since;
            baseEvent.person_Id__c = personProtectionActivatedPayload.personId;
            baseEvent.Timestamp__c = personProtectionActivatedPayload.timestamp;
            return baseEvent;
        }
    }

    public class PersonProtectionDeactivatedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonProtectionDeactivatedPayload personProtectionDeactivatedPayload = (ValitiveEventResponse.PersonProtectionDeactivatedPayload) payload;
            baseEvent.Type__c = personProtectionDeactivatedPayload.type;
            baseEvent.Since__c = personProtectionDeactivatedPayload.since;
            baseEvent.person_Id__c = personProtectionDeactivatedPayload.personId;
            baseEvent.Timestamp__c = personProtectionDeactivatedPayload.timestamp;
            return baseEvent;
        }
    }

    public class PersonLegalIdChangedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonLegalIdChangedPayload personLegalIdChangedPayload = (ValitiveEventResponse.PersonLegalIdChangedPayload) payload;
            baseEvent.Type__c = personLegalIdChangedPayload.type;
            baseEvent.Old_Legal_Id__c = personLegalIdChangedPayload.oldLegalId;
            baseEvent.Valid_Since__c = personLegalIdChangedPayload.validSince;
            baseEvent.Person_Id__c = personLegalIdChangedPayload.personId;
            baseEvent.Timestamp__c = personLegalIdChangedPayload.timestamp;
            baseEvent.Sync_Status__c = 'Awaiting Manual Review';
            return baseEvent;
        }
    }

    public class PersonGenderChangedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonGenderChangedPayload personGenderChangedPayload = (ValitiveEventResponse.PersonGenderChangedPayload) payload;
            baseEvent.Type__c = personGenderChangedPayload.type;
            baseEvent.Gender__c = personGenderChangedPayload.gender;
            baseEvent.Old_Gender__c = personGenderChangedPayload.oldGender;
            baseEvent.Timestamp__c = personGenderChangedPayload.timestamp;
            baseEvent.Person_Id__c = personGenderChangedPayload.personId;
            baseEvent.Sync_Status__c = 'Awaiting Manual Review';
            return baseEvent;
        }
    }

    public class PersonAddrChangedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonAddrChangedPayload personAddrChangedPayload = (ValitiveEventResponse.PersonAddrChangedPayload) payload;
            baseEvent.Type__c = personAddrChangedPayload.type;
            baseEvent.Person_Id__c = personAddrChangedPayload.personId;
            baseEvent.Timestamp__c = personAddrChangedPayload.timestamp;
            baseEvent.Valid_Since__c = personAddrChangedPayload.validSince;

            Type addressType = personAddrChangedPayload.address != null ? personAddrChangedPayload.address.getClassType() : null;
            Type oldAddressType = personAddrChangedPayload.oldAddress != null ? personAddrChangedPayload.oldAddress.getClassType() : null;
            
            //WE DO NOT CARE FOR NEW RAW ADDRESSES OR NULL ADDRESSES
            if(addressType == null){
                return null;
            }

            if (addressType == ValitiveAddress.SwedishAddress.class) {
                ValitiveAddress.SwedishAddress swedishAddress = (ValitiveAddress.SwedishAddress) personAddrChangedPayload.address;
                baseEvent = ValitiveEventHandler.mapSwedishAddress(baseEvent, swedishAddress);
            } else if (addressType == ValitiveAddress.RawAddress.class) {
                ValitiveAddress.RawAddress rawAddress = (ValitiveAddress.RawAddress) personAddrChangedPayload.address;
                if(rawAddress.kind != 'FOREIGN'){
                    return null;
                }
                baseEvent = ValitiveEventHandler.mapRawAddress(baseEvent, rawAddress);
            }
            if (oldAddressType == ValitiveAddress.SwedishAddress.class) {
                ValitiveAddress.SwedishAddress oldSwedishAddress = (ValitiveAddress.SwedishAddress) personAddrChangedPayload.oldAddress;
                baseEvent = ValitiveEventHandler.mapOldSwedishAddress(baseEvent, oldSwedishAddress);
            } else if (oldAddressType == ValitiveEventResponse.RawAddress.class) {
                ValitiveAddress.RawAddress oldRawAddress = (ValitiveAddress.RawAddress) personAddrChangedPayload.oldAddress;
                baseEvent = ValitiveEventHandler.mapOldRawAddress(baseEvent, oldRawAddress);
            }
            return baseEvent;

        }
    } 

    public class PersonAddrCorrectedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonAddrCorrectedPayload personAddrCorrectedPayload = (ValitiveEventResponse.PersonAddrCorrectedPayload) payload;
            baseEvent.Type__c = personAddrCorrectedPayload.type;
            baseEvent.Person_Id__c = personAddrCorrectedPayload.personId;
            baseEvent.Timestamp__c = personAddrCorrectedPayload.timestamp;
            baseEvent.Valid_Since__c = personAddrCorrectedPayload.validSince;

            Type addressType = personAddrCorrectedPayload.address != null ? personAddrCorrectedPayload.address.getClassType() : null;
            Type oldAddressType = personAddrCorrectedPayload.oldAddress != null ? personAddrCorrectedPayload.oldAddress.getClassType() : null;

            //WE DO NOT CARE FOR NEW RAW ADDRESSES OR NULL ADDRESSES
            if(addressType == null){
                return null;
            }

            if (addressType == ValitiveAddress.SwedishAddress.class) {
                ValitiveAddress.SwedishAddress swedishAddress = (ValitiveAddress.SwedishAddress) personAddrCorrectedPayload.address;
                baseEvent = ValitiveEventHandler.mapSwedishAddress(baseEvent, swedishAddress);
            } else if (addressType == ValitiveAddress.RawAddress.class) {
                ValitiveAddress.RawAddress rawAddress = (ValitiveAddress.RawAddress) personAddrCorrectedPayload.address;
                if(rawAddress.kind != 'FOREIGN'){
                    return null;
                }
                baseEvent = ValitiveEventHandler.mapRawAddress(baseEvent, rawAddress);
            }

            if (oldAddressType == ValitiveAddress.SwedishAddress.class) {
                ValitiveAddress.SwedishAddress oldSwedishAddress = (ValitiveAddress.SwedishAddress) personAddrCorrectedPayload.oldAddress;
                baseEvent = ValitiveEventHandler.mapOldSwedishAddress(baseEvent, oldSwedishAddress);
            } else if (oldAddressType == ValitiveAddress.RawAddress.class) {
                ValitiveAddress.RawAddress oldRawAddress = (ValitiveAddress.RawAddress) personAddrCorrectedPayload.oldAddress;
                baseEvent = ValitiveEventHandler.mapOldRawAddress(baseEvent, oldRawAddress);
            }
            return baseEvent;
        }
    }

    public class PersonNameChangedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonNameChangedPayload personNameChangedPayload = (ValitiveEventResponse.PersonNameChangedPayload) payload;
            baseEvent.Type__c = personNameChangedPayload.type;
            baseEvent.Person_Legal_Id__c = personNameChangedPayload.personLegalId;
            baseEvent.Person_Id__c = personNameChangedPayload.personId;
            baseEvent.Timestamp__c = personNameChangedPayload.timestamp;
            baseEvent.Given_Name__c = personNameChangedPayload.givenName;
            baseEvent.Old_Given_Name__c = personNameChangedPayload.oldGivenName;
            baseEvent.FirstName__c = personNameChangedPayload.firstName;
            baseEvent.Old_FirstName__c = personNameChangedPayload.oldFirstName;
            baseEvent.MiddleName__c = personNameChangedPayload.middleName;
            baseEvent.Old_MiddleName__c = personNameChangedPayload.oldMiddleName;
            baseEvent.LastName__c = personNameChangedPayload.lastName;
            baseEvent.Old_LastName__c = personNameChangedPayload.oldLastName;
            baseEvent.Valid_Since__c = personNameChangedPayload.validSince;
            return baseEvent;
        }
    }

    public class PersonDeceasedEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonDeceasedPayload personDeceasedPayload = (ValitiveEventResponse.PersonDeceasedPayload) payload;
            baseEvent.Type__c = personDeceasedPayload.type;
            baseEvent.Person_Id__c = personDeceasedPayload.personId;
            baseEvent.Timestamp__c = personDeceasedPayload.timestamp;
            baseEvent.Deceased_On__c = personDeceasedPayload.deceasedOn;
            baseEvent.Deceased_On_Month__c = personDeceasedPayload.deceasedOnMonth;
            baseEvent.Deceased_On_Year__c = personDeceasedPayload.deceasedOnYear;
            return baseEvent;
        }
    }

    public class PersonGuardEvent implements IValitiveEventHandler {
        public Valitive_Event__c handleEvent(Valitive_Event__c baseEvent, ValitiveEventResponse.Payload payload) {
            ValitiveEventResponse.PersonGuardPayload personGuardPayload = (ValitiveEventResponse.PersonGuardPayload) payload;
            baseEvent.Type__c = personGuardPayload.type;
            baseEvent.Person_Id__c = personGuardPayload.personId;
            baseEvent.Timestamp__c = personGuardPayload.timestamp;
            baseEvent.Guardianship_Type__c = personGuardPayload.guardianshipInfo.type;
            baseEvent.Guarded_Since__c = personGuardPayload.guardianshipInfo.guardedSince;
            return baseEvent;
        }
    }


    private static Valitive_Event__c mapSwedishAddress(Valitive_Event__c event, ValitiveAddress.SwedishAddress swedishAddress){
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

    private static Valitive_Event__c mapRawAddress(Valitive_Event__c event, ValitiveAddress.RawAddress rawAddress){
        event.Address_Type__c = rawAddress.type;
        event.Country__c = rawAddress.country;
        event.Address_Lines__c = String.join(rawAddress.addressLines, '\n');
        event.Address_Kind__c = rawAddress.kind;
        return event;
    }

    private static Valitive_Event__c mapOldSwedishAddress(Valitive_Event__c event, ValitiveAddress.SwedishAddress swedishAddress){
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

    private static Valitive_Event__c mapOldRawAddress(Valitive_Event__c event, ValitiveAddress.RawAddress rawAddress){
        event.Old_Address_Type__c = rawAddress.type;
        event.Old_Country__c = rawAddress.country;
        event.Old_Address_Lines__c = String.join(rawAddress.addressLines, '\n');
        return event;
    }
    

}