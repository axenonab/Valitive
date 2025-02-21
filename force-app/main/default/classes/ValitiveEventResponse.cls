public class ValitiveEventResponse {
    public List<Event> events = new List<Event>();

    public static ValitiveEventResponse parse(String json){
        return new ValitiveEventResponse(json);
    }

    public ValitiveEventResponse(String json){
        List<Object> parsed = (List<Object>) System.JSON.deserializeUntyped(json);
        for(Object obj : parsed){
            events.add(new Event((Map<String, Object>) obj));
        }         
    }

    public class Event {
        public String id;
        public Datetime detectedAt;
        public String monitoringSetId;
        public List<String> subjectIds;
        public Payload payload;

        public Event(Map<String, Object> obj){
            this.id = (String) obj.get('id');
            this.detectedAt = (Datetime) System.JSON.deserialize(System.JSON.serialize(obj.get('detectedAt')), Datetime.class);
            this.monitoringSetId = (String) obj.get('monitoringSetId');
            this.subjectIds = (List<String>) System.JSON.deserialize(System.JSON.serialize(obj.get('subjectIds')), List<String>.class);
            this.payload = parsePayload((Map<String, Object>) obj.get('payload'));
        }

        public Payload parsePayload(Map<String, Object> payload){
            String type = (String) payload.get('_type');
            
            switch on type {
                when 'SE_PERSON_ADDR_CHANGED' {
                    return new PersonAddrChangedPayload(payload);
                }
                when 'SE_PERSON_ADDR_CORRECTED' {
                    return new PersonAddrCorrectedPayload(payload);
                }
                when 'PERSON_DECEASED' {
                    return new PersonDeceasedPayload(payload);
                }
                when 'SE_PERSON_NAME_CHANGED' {
                    return new PersonNameChangedPayload(payload);
                }
                when 'PHONE_BOUND' {
                    return new PhoneBoundPayload(payload);
                }
                when 'PHONE_UNBOUND' {
                    return new PhoneUnboundPayload(payload);
                }
                when 'PERSON_PROTECTION_ACTIVATED' {
                    return new PersonProtectionActivatedPayload(payload);
                }
                when 'PERSON_PROTECTION_DEACTIVATED' {
                    return new PersonProtectionDeactivatedPayload(payload);
                }
                when 'PERSON_LEGAL_ID_CHANGED' {
                    return new PersonLegalIdChangedPayload(payload);
                }
                when 'PERSON_GENDER_CHANGED' {
                    return new PersonGenderChangedPayload(payload);
                }
                when 'SE_GUARD_ADDED' {
                    return new PersonGuardPayload(payload);
                }
                when 'SE_GUARD_REMOVED' {
                    return new PersonGuardPayload(payload);
                }
                when 'SE_GUARD_CHANGED' {
                    return new PersonGuardPayload(payload);
                }
                when else {
                    return null;
                }
            }
        }
    }



    public abstract class Payload {

        public Type getClassType(){

            if (this instanceof ValitiveEventResponse.PhoneBoundPayload) {
                return ValitiveEventResponse.PhoneBoundPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PhoneUnboundPayload) {
                return ValitiveEventResponse.PhoneUnboundPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonProtectionActivatedPayload) {
                return ValitiveEventResponse.PersonProtectionActivatedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonProtectionDeactivatedPayload) {
                return ValitiveEventResponse.PersonProtectionDeactivatedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonLegalIdChangedPayload) {
                return ValitiveEventResponse.PersonLegalIdChangedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonGenderChangedPayload) {
                return ValitiveEventResponse.PersonGenderChangedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonGuardPayload) {
                return ValitiveEventResponse.PersonGuardPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonAddrChangedPayload) {
                return ValitiveEventResponse.PersonAddrChangedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonAddrCorrectedPayload) {
                return ValitiveEventResponse.PersonAddrCorrectedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonNameChangedPayload) {
                return ValitiveEventResponse.PersonNameChangedPayload.class;
            }
            if (this instanceof ValitiveEventResponse.PersonDeceasedPayload) {
                return ValitiveEventResponse.PersonDeceasedPayload.class;
            }
            return null;
        }
    }

   

    public class PersonDeceasedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public Date deceasedOn;
        public String deceasedOnMonth;
        public Integer deceasedOnYear;

        public PersonDeceasedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.deceasedOn = (Date) System.JSON.deserialize((String) payload.get('deceasedOn'), Date.class);
            this.deceasedOnMonth = (String) payload.get('deceasedOnMonth');
            this.deceasedOnYear = (Integer) payload.get('deceasedOnYear');
        }
    }

    public class PersonNameChangedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public Date validSince;
        public String givenName;
        public String firstName;
        public String middleName;
        public String lastName;
        public String oldGivenName;
        public String oldFirstName;
        public String oldMiddleName;
        public String oldLastName;

        public PersonNameChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = payload.containsKey('validSince') ? ((Datetime) System.JSON.deserialize(System.Json.serialize(payload.get('validSince')), Datetime.class)).date() : null;
            this.givenName = (String) payload.get('givenName');
            this.firstName = (String) payload.get('firstName');
            this.middleName = (String) payload.get('middleName');
            this.lastName = (String) payload.get('lastName');
            this.oldGivenName = (String) payload.get('oldGivenName');
            this.oldFirstName = (String) payload.get('oldFirstName');
            this.oldMiddleName = (String) payload.get('oldMiddleName');
            this.oldLastName = (String) payload.get('oldLastName');
        }
    }

    public class PhoneBoundPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String telNumber;
        public String partyId;
        public String kind;
        public Date registeredSince;
        public String areaCode;
        public String provider;
        public String countryCode;

        public PhoneBoundPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.telNumber = (String) payload.get('number');
            this.partyId = (String) payload.get('partyId');
            this.kind = (String) payload.get('kind');
            this.registeredSince = payload.containsKey('registeredSince') ? (Date) System.JSON.deserialize((String) payload.get('registeredSince'), Date.class) : null;
            this.areaCode = (String) payload.get('areaCode');
            this.provider = (String) payload.get('provider');
            this.countryCode = (String) payload.get('countryCode');
        }
    }

    public class PhoneUnboundPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String telNumber;
        public String partyId;
        public String kind;
        public Date registeredSince;
        public String areaCode;
        public String provider;
        public String countryCode;

        public PhoneUnboundPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.telNumber = (String) payload.get('number');
            this.partyId = (String) payload.get('partyId');
            this.kind = (String) payload.get('kind');
            this.registeredSince = payload.containsKey('registeredSince') ? (Date) System.JSON.deserialize((String) payload.get('registeredSince'), Date.class) : null;
            this.areaCode = (String) payload.get('areaCode');
            this.provider = (String) payload.get('provider');
            this.countryCode = (String) payload.get('countryCode');
        }
    }

    public class PersonProtectionActivatedPayload extends Payload {
        public String personId;
        public String personLegalId;
        public Date since;
        public Datetime timestamp;
        public String type;

        public PersonProtectionActivatedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.since = payload.containsKey('since') ? (Date) System.JSON.deserialize((String) payload.get('since'), Date.class) : null;
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
        }
    }

    public class PersonProtectionDeactivatedPayload extends Payload {
        public String personId;
        public String personLegalId;
        public Datetime timestamp;
        public Date since;
        public String type;

        public PersonProtectionDeactivatedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.since = (Date) System.JSON.deserialize((String) payload.get('since'), Date.class);
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
        }
    }

    public class PersonLegalIdChangedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public Date validSince;
        public String oldLegalId;
        public Integer changeCode;
        public String personId;
        public String personLegalId;

        public PersonLegalIdChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.validSince = payload.containsKey('validSince') ? ((Datetime) System.JSON.deserialize(System.Json.serialize(payload.get('validSince')), Datetime.class)).date() : null;
            this.oldLegalId = (String) payload.get('oldLegalId');
            this.changeCode = (Integer) payload.get('changeCode');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
        }
    }

    public class PersonGenderChangedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public String gender;
        public String oldGender;

        public PersonGenderChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.oldGender = (String) payload.get('oldGender');
            this.gender = (String) payload.get('gender');
        }
    }

    public class PersonGuardPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public SwedishGuardianshipInfo guardianshipInfo;

        public PersonGuardPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.guardianshipInfo = new SwedishGuardianshipInfo((Map<String, Object>) payload.get('guardianshipInfo'));
        }
    }

    public class SwedishGuardianshipInfo {
        public String type;
        public Date guardedSince;
        public Date decisionDate;
        public Date publicationDate;
        public String publicationText;

        public SwedishGuardianshipInfo(Map<String, Object> guardianshipInfo){
            this.type = (String) guardianshipInfo.get('type');
            this.guardedSince = (Date) System.JSON.deserialize((String) guardianshipInfo.get('guardedSince'), Date.class);
            this.decisionDate = (Date) System.JSON.deserialize((String) guardianshipInfo.get('decisionDate'), Date.class);
            this.publicationDate = (Date) System.JSON.deserialize((String) guardianshipInfo.get('publicationDate'), Date.class);
            this.publicationText = (String) guardianshipInfo.get('publicationText');
        }
    }

    public class PersonAddrChangedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public Date validSince;
        public ValitiveAddress.Address address;
        public ValitiveAddress.Address oldAddress;
        public String addressKind;

        public PersonAddrChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = payload.containsKey('validSince') ? ((Datetime) System.JSON.deserialize(System.Json.serialize(payload.get('validSince')), Datetime.class)).date() : null;
            this.address = ValitiveAddress.parseAddress((Map<String, Object>) payload.get('address'));
            this.oldAddress = ValitiveAddress.parseAddress((Map<String, Object>) payload.get('oldAddress'));
            this.addressKind = (String) payload.get('addressKind');
        }

    }

    public class PersonAddrCorrectedPayload extends Payload {
        public String type;
        public String id;
        public Datetime timestamp;
        public String personId;
        public String personLegalId;
        public Date validSince;
        public ValitiveAddress.Address address;
        public ValitiveAddress.Address oldAddress;
        public String addressKind;

        public PersonAddrCorrectedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (Datetime) System.JSON.deserialize(System.JSON.serialize(payload.get('timestamp')), Datetime.class);
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = payload.containsKey('validSince') ? ((Datetime) System.JSON.deserialize(System.Json.serialize(payload.get('validSince')), Datetime.class)).date() : null;
            this.address = ValitiveAddress.parseAddress((Map<String, Object>) payload.get('address'));
            this.oldAddress = ValitiveAddress.parseAddress((Map<String, Object>) payload.get('oldAddress'));
            this.addressKind = (String) payload.get('addressKind');
        }
    }

  

}
