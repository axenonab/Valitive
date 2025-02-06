public class ValitiveMonitoringSetSubjectResponse {
    
    public String type;
    public String id;
    public String monitoringSetId;
    public DateTime updatedAt;
    public Data data;


    public ValitiveMonitoringSetSubjectResponse(String json){
        Map<String, Object> obj = (Map<String, Object>) System.JSON.deserializeUntyped(json);
        this.type = (String) obj.get('_type');
        this.id = (String) obj.get('id');
        this.monitoringSetId = (String) obj.get('monitoringSetId');
        this.updatedAt = obj.containsKey('updatedAt') ? (Datetime) System.JSON.deserialize(System.JSON.serialize(obj.get('updatedAt')), DateTime.class) : null;
        this.data = parseData((Map<String, Object>) obj.get('data'));

    }

    public static ValitiveMonitoringSetSubjectResponse parse(String json){
        return new ValitiveMonitoringSetSubjectResponse(json);
    }
    

    public static Data parseData(Map<String, Object> data){
        String type = (String) data.get('_type');
            switch on type {
                when 'SE_PERSON' {
                    return new SEPerson(data);
                }
                when 'SE_ORG' {
                    return new SEOrg(data);
                }
                when else {
                    return null;
            }
        }
    }


    public static Name parseName(Map<String, Object> name){
        return new Name(name);
    }

    public static PersonalPhone parsePhone(Map<String, Object> phone){
        return new PersonalPhone(phone);
    }

    public static GuardianShipInfo parseGuardianShipInfo(Map<String, Object> guardianShipInfo){
        return new GuardianShipInfo(guardianShipInfo);
    }

    public class GuardianShipInfo {
        public String type;
        public Date guardedSince;
        public Datetime decisionDate;
        public Datetime publicationDate;
        public String publicationText;

        public GuardianShipInfo(Map<String, Object> guardianShipInfo){
            this.type = (String) guardianShipInfo.get('type');
            this.guardedSince = (Date) System.JSON.deserialize((String) guardianshipInfo.get('guardedSince'), Date.class);
            this.decisionDate = guardianShipInfo.containsKey('decisionDate') ? (Datetime) System.JSON.deserialize((String) guardianShipInfo.get('decisionDate'), Datetime.class) : null;
            this.publicationDate = guardianShipInfo.containsKey('publicationDate') ? (Datetime) System.JSON.deserialize((String) guardianShipInfo.get('publicationDate'), Datetime.class) : null;
            this.publicationText = (String) guardianShipInfo.get('publicationText');
        }
    }

    public class Name {
        public String country;
        public String lastName;
        public String givenName;
        public List<String> names;

        public Name(Map<String, Object> name){
            this.country = (String) name.get('country');
            this.lastName = (String) name.get('lastName');
            this.givenName = (String) name.get('givenName');
            this.names = (List<String>) System.JSON.deserialize(System.JSON.serialize(name.get('names')), List<String>.class);
        }
    }

    public class PersonalPhone {
        public String type;
        public String telNumber;
        public String areaCode;
        public String provider;
        public String operator;
        public Datetime registeredSince;
        public Date estPortDate;
        public String kind;
        public Integer priority;

        public PersonalPhone(Map<String, Object> phone){
            this.type = (String) phone.get('type');
            this.telNumber = (String) phone.get('number');
            this.areaCode = (String) phone.get('areaCode');
            this.provider = (String) phone.get('provider');
            this.operator = (String) phone.get('operator');
            this.registeredSince = phone.containsKey('registeredSince') ? (Datetime) System.JSON.deserialize((String) phone.get('registeredSince'), Datetime.class) : null;
            this.estPortDate = phone.containsKey('estPortDate') ? (Date) System.JSON.deserialize(System.JSON.serialize(phone.get('estPortDate')), Date.class) : null;
            this.kind = (String) phone.get('kind');
            this.priority = (Integer) phone.get('priority');
        }
    }


    public abstract class Data {}

    public class SEPerson extends Data {
        public String id;
        public String type;
        public String country;
        public String legalId;
        public Date birthDate;
        public Date deceasedDate;
        public String gender;
        public Name name;
        public string tempId;
        public List<ValitiveAddress.Address> addresses = new List<ValitiveAddress.Address>();
        public String registrationStatus;
        public List<PersonalPhone> phones = new List<PersonalPhone>();
        public GuardianShipInfo guardianShipInfo;

        public SEPerson(Map<String, Object> data){
            this.id = (String) data.get('id');
            this.type = (String) data.get('_type');
            this.country = (String) data.get('country');
            this.legalId = (String) data.get('legalId');
            this.birthDate = data.containsKey('birthDate') ? (Date) System.JSON.deserialize(System.JSON.serialize(data.get('birthDate')), Date.class) : null;
            this.deceasedDate = data.containsKey('deceasedDate') ? (Date) System.JSON.deserialize(System.JSON.serialize(data.get('deceasedDate')), Date.class) : null;
            this.gender = (String) data.get('gender');
            this.name = ValitiveMonitoringSetSubjectResponse.parseName((Map<String, Object>) data.get('name'));
            this.tempId = (String) data.get('tempId');
            for (Object address : (List<Object>) data.get('addresses')) {
                this.addresses.add(ValitiveAddress.parseAddress((Map<String, Object>) address));
            }
            this.registrationStatus = (String) data.get('registrationStatus');
            for (Object phone : (List<Object>) data.get('phones')) {
                this.phones.add(parsePhone((Map<String, Object>) phone));
            }
            this.guardianShipInfo = data.containsKey('guardianShipInfo') ? parseGuardianShipInfo((Map<String, Object>) data.get('guardianShipInfo')) : null;
        }
    }

    public class SEOrg extends Data {
        
        public SEOrg(Map<String, Object> data){

        }
    }


}