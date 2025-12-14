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

    // Static method to parse a single response
    public static ValitiveMonitoringSetSubjectResponse parse(String json){
        return new ValitiveMonitoringSetSubjectResponse(json);
    }

    // Static method to parse a list of responses
    public static List<ValitiveMonitoringSetSubjectResponse> parseList(String json) {
        List<ValitiveMonitoringSetSubjectResponse> responseList = new List<ValitiveMonitoringSetSubjectResponse>();
        List<Object> objList = (List<Object>) System.JSON.deserializeUntyped(json);
        
        for (Object obj : objList) {
            String jsonString = System.JSON.serialize(obj);
            responseList.add(new ValitiveMonitoringSetSubjectResponse(jsonString));
        }

        return responseList;
    }


    public static Data parseData(Map<String, Object> data){
        String type = (String) data.get('_type');
            switch on type {
                when 'SE_PERSON' {
                    return new SEPerson(data);
                }
                // new type.
                when 'SE_ORGANIZATION' {
                    return new SEOrganization(data);
                }
                // keep support for old type.
                /*when 'SE_ORG' {
                    return new SEOrg(data);
                }*/
                when else {
                    return null;
            }
        }
    }


    // Parsing helper methods
    public static Name parseName(Map<String, Object> name){
        return new Name(name);
    }

    public static PersonalPhone parsePhone(Map<String, Object> phone){
        return new PersonalPhone(phone);
    }

    public static GuardianShipInfo parseGuardianShipInfo(Map<String, Object> guardianShipInfo){
        return new GuardianShipInfo(guardianShipInfo);
    }

    public static BasicPhone parseBasicPhone(Map<String, Object> phone){
        return new BasicPhone(phone);
    }

    public static OrgName parseOrgName(Map<String, Object> name){
        return new OrgName(name);
    }

    // Inner classes
    public class BasicPhone {
        public String type;
        public String telNumber;
        public String areaCode;

        public BasicPhone(Map<String, Object> phone){
            this.type = (String) phone.get('type');
            this.telNumber = (String) phone.get('number');
            this.areaCode = (String) phone.get('areaCode');
        }
    }

    public class OrgName {
        public String name;
        public String rawName;
        public String kind;

        public OrgName(Map<String, Object> orgName){
            this.name = (String) orgName?.get('name');
            this.rawName = (String) orgName?.get('rawName');
            this.kind = (String) orgName?.get('kind');
        }
    }

    public class BusinessCategory {
        public String code;
        public String description;

        public BusinessCategory(){}

        public BusinessCategory(Map<String, Object> primaryBusinessCategory){
            this.code = (String) primaryBusinessCategory.get('code');
            this.description = (String) primaryBusinessCategory.get('description');
        }
    }

    
    public class LegalForm {
        public String code;
        public String name;

        public LegalForm(){}

        public LegalForm(Map<String, Object> legalForm){
            this.code = (String) legalForm.get('code');
            this.name = (String) legalForm.get('name');
        }
    }

    public class FinancialStatement {
        public Date period;
        public Integer durationMonths;
        public Decimal equityRatio;
        public Decimal liquidityRatio;
        public Decimal returnOnEquity;
        public Decimal returnOnAssets;
        public Decimal debtRatio;
        public Decimal profitMargin;
        public Decimal totalTurnover;
        public Decimal grossMargin;
        public Decimal yearResult;

        public FinancialStatement(Map<String, Object> financialStatement){
            this.period = (Date) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('period')), Date.class);
            this.durationMonths = (Integer) financialStatement.get('durationMonths');
            this.equityRatio = financialStatement.containsKey('equityRatio') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('equityRatio')), Decimal.class) : null;
            this.liquidityRatio = financialStatement.containsKey('liquidityRatio') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('liquidityRatio')), Decimal.class) : null;
            this.returnOnEquity = financialStatement.containsKey('returnOnEquity') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('returnOnEquity')), Decimal.class) : null;
            this.returnOnAssets = financialStatement.containsKey('returnOnAssets') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('returnOnAssets')), Decimal.class) : null;
            this.debtRatio = financialStatement.containsKey('debtRatio') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('debtRatio')), Decimal.class) : null;
            this.profitMargin = financialStatement.containsKey('profitMargin') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('profitMargin')), Decimal.class) : null;
            this.totalTurnover = financialStatement.containsKey('totalTurnover') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('totalTurnover')), Decimal.class) : null;
            this.grossMargin = financialStatement.containsKey('grossMargin') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('grossMargin')), Decimal.class) : null;
            this.yearResult = financialStatement.containsKey('yearResult') ? (Decimal) System.JSON.deserialize(System.JSON.serialize(financialStatement.get('yearResult')), Decimal.class) : null;
        }

        public FinancialStatement(){}
    }

    public class Financials {
        public Boolean stockExchangeListed = false;
        public integer shareCapital;
        public List<FinancialStatement> financialStatements = new List<FinancialStatement>(); 
        public String turnoverGroup;

        public Financials(){}

        public Financials(Map<String, Object> financials){
            this.stockExchangeListed = (Boolean) financials.get('stockExchangeListed');
            this.shareCapital = financials.containsKey('shareCapital') ? (Integer) System.JSON.deserialize(System.JSON.serialize(financials.get('shareCapital')), Integer.class) : null;
            this.financialStatements = financials.containsKey('financialStatements') ? (List<FinancialStatement>) System.JSON.deserialize(System.JSON.serialize(financials.get('financialStatements')), List<FinancialStatement>.class) : new List<FinancialStatement>();
            this.turnoverGroup = (String) financials.get('turnoverGroup');
        }
    }

    public class LifeCycle {
        public String status;
        public Integer establishedOnYear;
        public Date establishedOn;
        
        public LifeCycle(Map<String, Object> lifeCycle){
            this.status = lifeCycle.containsKey('status') ? (String) ((Map<String, Object>) lifeCycle.get('status')).get('value') : null;
            this.establishedOnYear = (Integer) lifeCycle.get('establishedInYear');
            this.establishedOn = lifeCycle.containsKey('establishedOn') ? (Date) System.JSON.deserialize(System.JSON.serialize(lifeCycle.get('establishedOn')), Date.class) : null;
        }
    }

    public class ManPowerInfo{
        public Integer minNrOfEmployeesHQ;
        public Integer maxNrOfEmployeesHQ;
        public Integer minNrOfEmployeesOrg;
        public Integer maxNrOfEmployeesOrg;
        public Integer nrOfEmployeesOrg;
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
            
            this.country = (String) name?.get('country');
            this.lastName = (String) name?.get('lastName');
            this.givenName = (String) name?.get('givenName');
            this.names = name != null ? (List<String>) System.JSON.deserialize(System.JSON.serialize(name.get('names')), List<String>.class) : new List<String>();
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
            this.name = data.containsKey('name') ? ValitiveMonitoringSetSubjectResponse.parseName((Map<String, Object>) data.get('name')) : null;
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

    // new SE_ORGANIZATION related class.
    public class PrimaryIndustry {
        public Industry primary;
        public List<Industry> altClassifications = new List<Industry>();

        public PrimaryIndustry(Map<String, Object> data) {
            this.primary = new Industry((Map<String, Object>) data.get('primary'));
            for (Object alt : (List<Object>) data.get('altClassifications')) {
                this.altClassifications.add(new Industry((Map<String, Object>) alt));
            }
        }
    }

    // new SE_ORGANIZATION related class.
    public class Industry {
        public String standardName;
        public String code;
        public String description;

        public Industry(Map<String, Object> data) {
            this.standardName = (String) data.get('standardName');
            this.code = (String) data.get('code');
            this.description = (String) data.get('description');
        }
    }

    // new SE_ORGANIZATION related class.
    public class StatusInfo {
        public String status;
        public Date validFrom;
        public String bvStatus;
        public String bvStatusText;

        public StatusInfo(Map<String, Object> data) {

            if (data.containsKey('status')) {
                Map<String, Object> s = (Map<String, Object>) data.get('status');
                this.status = (String) s.get('value');
                this.validFrom = s.containsKey('validFrom') ? (Date) JSON.deserialize(JSON.serialize(s.get('validFrom')), Date.class) : null;
            }

            this.bvStatus = (String) data.get('bvStatus');
            this.bvStatusText = (String) data.get('bvStatusText');
        }
    }

    // new SE_ORGANIZATION related class.
    public class RelatedParty {
        public String name;
        public String legalId;
        public String partyId;
        public String function;
        public String partyType;

        public Decimal minShares;
        public Decimal maxShares;

        public RelatedParty(Map<String, Object> data) {
            this.name = (String) data.get('name');
            this.legalId = (String) data.get('legalId');
            this.partyId = (String) data.get('partyId');
            this.function = (String) data.get('function');
            this.partyType = (String) data.get('partyType');

            if (data.containsKey('shares')) {
                Map<String, Object> shares = (Map<String, Object>) data.get('shares');
                this.minShares = (Decimal) shares.get('min');
                this.maxShares = (Decimal) shares.get('max');
            }
        }
    }

    // new SE_ORGANIZATION related class.
    public class EmploymentHistory {
        public Date date_x;
        public String period;
        public Integer count;
        public Integer min;
        public Integer max;

        public EmploymentHistory(Map<String, Object> data) {
            this.date_x = (Date) JSON.deserialize(JSON.serialize(data.get('date')), Date.class);
            this.period = (String) data.get('period');
            this.count = (Integer) data.get('count');

            if (data.containsKey('interval')) {
                Map<String, Object> i = (Map<String, Object>) data.get('interval');
                this.min = (Integer) i.get('min');
                this.max = (Integer) i.get('max');
            }
        }
    }

    public class Phone {
        public String id_x;   
        public String country;
        public String type;
        public String phoneNumber;

        public Phone(Map<String, Object> data) {
            this.id_x = (String) data.get('id');
            this.country = (String) data.get('country');
            this.type = (String) data.get('type');
            this.phoneNumber = (String) data.get('number');
        }
    }

    // New class for new structure.
    public class SEOrganization extends Data {

        public String id_x;
        public String type;
        public String country;
        public String legalId;

        public List<OrgName> names = new List<OrgName>();
        public List<ValitiveAddress.Address> addresses = new List<ValitiveAddress.Address>();

        public List<String> urls = new List<String>();
        public List<String> emails = new List<String>();
        //public List<String> phones = new List<String>();

        public Boolean adProtection;
        public Boolean operational;

        public PrimaryIndustry primaryIndustry;
        public StatusInfo statusInfo;
        public LegalForm legalForm;

        public Date incorpDate;
        public String capital;
        public String currency_x;
        public String signatory;
        public String businessDescription;

        public List<RelatedParty> relatedParties = new List<RelatedParty>();
        public List<EmploymentHistory> employmentHistory = new List<EmploymentHistory>();
        public List<Phone> phones = new List<Phone>();

        public SEOrganization(Map<String, Object> data) {

            this.id_x = (String) data.get('id');
            this.type = (String) data.get('_type');
            this.country = (String) data.get('country');
            this.legalId = (String) data.get('legalId');

            for (Object n : (List<Object>) data.get('names')) {
                this.names.add(new OrgName((Map<String, Object>) n));
            }

            for (Object a : (List<Object>) data.get('addresses')) {
                this.addresses.add(
                    ValitiveAddress.parseAddress((Map<String, Object>) a)
                );
            }

            this.adProtection = (Boolean) data.get('adProtection');
            this.operational = (Boolean) data.get('operational');

            this.primaryIndustry = data.containsKey('primaryIndustry')
                ? new PrimaryIndustry((Map<String, Object>) data.get('primaryIndustry'))
                : null;

            this.statusInfo = data.containsKey('statusInfo')
                ? new StatusInfo((Map<String, Object>) data.get('statusInfo'))
                : null;

            this.legalForm = data.containsKey('legalForm')
                ? new LegalForm((Map<String, Object>) data.get('legalForm'))
                : null;

            this.incorpDate = data.containsKey('incorpDate')
                ? (Date) JSON.deserialize(JSON.serialize(data.get('incorpDate')), Date.class)
                : null;

            this.capital = (String) data.get('capital');
            this.currency_x = (String) data.get('currency');
            this.signatory = (String) data.get('signatory');
            this.businessDescription = (String) data.get('businessDescription');

            // Handle lists.
            for (Object rp : (List<Object>) data.get('relatedParties')) {
                this.relatedParties.add(new RelatedParty((Map<String, Object>) rp));
            }

            for (Object eh : (List<Object>) data.get('employmentHistory')) {
                this.employmentHistory.add(new EmploymentHistory((Map<String, Object>) eh));
            }

            for (Object pn : (List<Object>) data.get('phones')) {
                this.phones.add(new Phone((Map<String, Object>) pn));
            }

            this.urls = data.containsKey('urls')
                ? (List<String>) JSON.deserialize(JSON.serialize(data.get('urls')), List<String>.class)
                : new List<String>();

            this.emails = data.containsKey('emails')
                ? (List<String>) JSON.deserialize(JSON.serialize(data.get('emails')), List<String>.class)
                : new List<String>();

        }
    }


    /* public class SEOrg extends Data {

        public String id;
        public String type;
        public String country;
        public String legalId;
        public List<BasicPhone> phones = new List<BasicPhone>();
        public List<String> urls = new List<String>();
        public List<String> emails = new List<String>();
        public OrgName orgName;
        public List<ValitiveAddress.Address> addresses = new List<ValitiveAddress.Address>();
        public String businessActivity;
        public BusinessCategory primaryBusinessCategory;
        public List<BusinessCategory> otherBusinessCategories;
        public LegalForm legalForm;
        public Financials financials;
        public LifeCycle lifeCycle;
        public ManPowerInfo manPowerInfo;
        
        public SEOrg(Map<String, Object> data){
            this.id = (String) data.get('id');
            this.type = (String) data.get('_type');
            this.country = (String) data.get('country');
            this.legalId = (String) data.get('legalId');
            for (Object phone : (List<Object>) data.get('phones')) {
                this.phones.add(parseBasicPhone((Map<String, Object>) phone));
            }
            this.urls = data.containsKey('urls') ? (List<String>) JSON.deserialize(System.JSON.serialize(data.get('urls')), List<String>.class) : new List<String>();
            this.emails = data.containsKey('emails') ? (List<String>) System.JSON.deserialize(System.JSON.serialize(data.get('emails')), List<String>.class) : new List<String>();
            this.orgName = parseOrgName((Map<String, Object>) data.get('orgName'));
            for (Object address : (List<Object>) data.get('addresses')) {
                this.addresses.add(ValitiveAddress.parseAddress((Map<String, Object>) address));
            }
            this.businessActivity = (String) data.get('businessActivity');
            this.primaryBusinessCategory = data.containsKey('primaryBusinessCategory') ? (BusinessCategory) JSON.deserialize(JSON.serialize(data.get('primaryBusinessCategory')), BusinessCategory.class) : new BusinessCategory();
            this.otherBusinessCategories = data.containsKey('otherBusinessCategories') ? (List<BusinessCategory>) JSON.deserialize(JSON.serialize(data.get('otherBusinessCategories')), List<BusinessCategory>.class) : new List<BusinessCategory>();
            this.legalForm = data.containsKey('legalForm') ? (LegalForm) JSON.deserialize(JSON.serialize(data.get('legalForm')), LegalForm.class) : new LegalForm();
            this.financials = data.containsKey('financials') ? new Financials((Map<String, Object>) data.get('financials')) : new Financials();
            this.lifeCycle = new LifeCycle((Map<String, Object>) data.get('lifecycle'));
            this.manPowerInfo = data.containsKey('manpower') ? (ManPowerInfo) JSON.deserialize(JSON.serialize(data.get('manpower')), ManPowerInfo.class) : new ManpowerInfo();

        }
    } */


}