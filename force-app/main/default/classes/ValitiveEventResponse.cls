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
        public String type;
        public String detectedAt;
        public String monitoringSetId;
        public List<String> subjectIds;
        public Payload payload;

        public Event(Map<String, Object> obj){
            this.id = (String) obj.get('id');
            this.type = (String) obj.get('_type');
            this.detectedAt = (String) obj.get('detectedAt');
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
                when 'SE_PERSON_DECEASED' {
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
                when else {
                    return null;
                }
            }
        }
    }



    public abstract class Payload {

        public Address parseAddress(Map<String, Object> address){
            String type = (String) address.get('_type');
            switch on type {
                when 'SE_NORMALIZED' {
                    return new SwedishAddress(address);
                }
                when 'RAW' {
                    return new RawAddress(address);
                }
                when else {
                    return null;
                }
            }
        }
    }

    public class PersonAddrCorrectedPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String personId;
        public String personLegalId;
        public String validSince;
        public Address address;
        public Address oldAddress;
        public String addressKind;

        public PersonAddrCorrectedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = (String) payload.get('validSince');
            this.address = parseAddress((Map<String, Object>) payload.get('address'));
            this.oldAddress = parseAddress((Map<String, Object>) payload.get('oldAddress'));
            this.addressKind = (String) payload.get('addressKind');
        }
    }

    public class PersonDeceasedPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String personId;
        public String personLegalId;
        public String deceasedOn;
        public String deceasedOnMonth;
        public String deceasedOnYear;

        public PersonDeceasedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.deceasedOn = (String) payload.get('deceasedOn');
            this.deceasedOnMonth = (String) payload.get('deceasedOnMonth');
            this.deceasedOnYear = (String) payload.get('deceasedOnYear');
        }
    }

    public class PersonNameChangedPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String personId;
        public String personLegalId;
        public String validSince;
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
            this.timestamp = (String) payload.get('timestamp');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = (String) payload.get('validSince');
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
        public String timestamp;
        public String telNumber;
        public String partyId;
        public String kind;
        public String registeredSince;
        public String areaCode;
        public String provider;
        public String countryCode;

        public PhoneBoundPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.telNumber = (String) payload.get('number');
            this.partyId = (String) payload.get('partyId');
            this.kind = (String) payload.get('kind');
            this.registeredSince = (String) payload.get('registeredSince');
            this.areaCode = (String) payload.get('areaCode');
            this.provider = (String) payload.get('provider');
            this.countryCode = (String) payload.get('countryCode');
        }
    }

    public class PhoneUnboundPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String telNumber;
        public String partyId;
        public String kind;
        public String registeredSince;
        public String areaCode;
        public String provider;
        public String countryCode;

        public PhoneUnboundPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.telNumber = (String) payload.get('number');
            this.partyId = (String) payload.get('partyId');
            this.kind = (String) payload.get('kind');
            this.registeredSince = (String) payload.get('registeredSince');
            this.areaCode = (String) payload.get('areaCode');
            this.provider = (String) payload.get('provider');
            this.countryCode = (String) payload.get('countryCode');
        }
    }

    public class PersonProtectionActivatedPayload extends Payload {
        public String personId;
        public String personLegalId;
        public String since;

        public PersonProtectionActivatedPayload(Map<String, Object> payload){
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.since = (String) payload.get('since');
        }
    }

    public class PersonProtectionDeactivatedPayload extends Payload {
        public String personId;
        public String personLegalId;
        public String since;

        public PersonProtectionDeactivatedPayload(Map<String, Object> payload){
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.since = (String) payload.get('since');
        }
    }

    public class PersonLegalIdChangedPayload extends Payload {
        public String id;
        public String timestamp;
        public String validSince;
        public String oldLegalId;
        public Integer changeCode;
        public String personId;
        public String personLegalId;

        public PersonLegalIdChangedPayload(Map<String, Object> payload){
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.validSince = (String) payload.get('validSince');
            this.oldLegalId = (String) payload.get('oldLegalId');
            this.changeCode = (Integer) payload.get('changeCode');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
        }
    }

    public class PersonGenderChangedPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String personId;
        public String personLegalId;
        public String gender;
        public String oldGender;

        public PersonGenderChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
        }
    }


    public class PersonAddrChangedPayload extends Payload {
        public String type;
        public String id;
        public String timestamp;
        public String personId;
        public String personLegalId;
        public String validSince;
        public Address address;
        public Address oldAddress;
        public String addressKind;

        public PersonAddrChangedPayload(Map<String, Object> payload){
            this.type = (String) payload.get('_type');
            this.id = (String) payload.get('id');
            this.timestamp = (String) payload.get('timestamp');
            this.personId = (String) payload.get('personId');
            this.personLegalId = (String) payload.get('personLegalId');
            this.validSince = (String) payload.get('validSince');
            this.address = parseAddress((Map<String, Object>) payload.get('address'));
            this.oldAddress = parseAddress((Map<String, Object>) payload.get('oldAddress'));
            this.addressKind = (String) payload.get('addressKind');
        }

    }

    public abstract class Address {}


    public class RawAddress extends Address {
        public String type;
        public String country;
        public List<String> addressLines;
        public String city;

        public RawAddress(Map<String, Object> address){
            this.type = (String) address.get('_type');
            this.country = (String) address.get('country');
            this.addressLines = (List<String>) System.JSON.deserialize(System.JSON.serialize(address.get('addressLines')), List<String>.class);
            this.city = (String) address.get('city');
        }
    }

    public class SwedishAddress extends Address{
        public String type;
        public String country;
        public Geolocation geolocation;
        public String postbox;
        public String street;
        public String street2;
        public String streetNumber;
        public string numberSuffix;
        public String flat;
        public String careOf;
        public String county;
        public String municipality;
        public String misc;
        public String floor;
        public String entrance;
        public String kind;

        public SwedishAddress(Map<String, Object> address){
            this.type = (String) address.get('_type');
            this.country = (String) address.get('country');
            this.geolocation = new Geolocation((Map<String, Object>) address.get('geolocation'));
            this.postbox = (String) address.get('postbox');
            this.street = (String) address.get('street');
            this.street2 = (String) address.get('street2');
            this.streetNumber = (String) address.get('number_x');
            this.numberSuffix = (String) address.get('numberSuffix');
            this.flat = (String) address.get('flat');
            this.careOf = (String) address.get('careOf');
            this.county = (String) address.get('county');
            this.municipality = (String) address.get('municipality');
            this.misc = (String) address.get('misc');
            this.floor = (String) address.get('floor');
            this.entrance = (String) address.get('entrance');
            this.kind = (String) address.get('kind');
        }
    }

    public class Geolocation {
        public String latitude;
        public String longetude;

        public Geolocation(Map<String, Object> geolocation){
            this.latitude = (String) geolocation?.get('lat');
            this.longetude = (String) geolocation?.get('long');
        }
    }

}
