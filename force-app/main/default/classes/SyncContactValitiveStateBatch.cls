public class SyncContactValitiveStateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {


    @TestVisible
    private ValitiveService valitiveService = new ValitiveService();

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Personal_Identity_Number__c, 
                MailingStreet,
                MailingCity,
                MailingState, 
                MailingPostalCode,
                MailingMunicipality__c,
                Foreign_Address__c
            FROM Contact
            WHERE IsInMonitoringSet__c = true
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<String, Contact> formatedSSNToContact = new Map<String, Contact>();

        for (Contact contact : contacts) {
            formatedSSNToContact.put(removeHyphen(contact.Personal_Identity_Number__c), contact);
        }

        Map<String, String> queryParams = new Map<String, String> {
            ValitiveQueryParams.MONITORING_SET_IDS => this.valitiveService.getPrivateMonitoringSetId(),
            ValitiveQueryParams.IDS => String.join(formatedSSNToContact.keySet(), ','),
            ValitiveQueryParams.ROW_LIMIT => '1000'
        };

        HttpResponse response = this.valitiveService.queryMonitoringSetScope(queryParams);

        List<ValitiveMonitoringSetSubjectResponse> parsedResponse = ValitiveMonitoringSetSubjectResponse.parseList(response.getBody());
        for(ValitiveMonitoringSetSubjectResponse monitoringSetSubjectResponse : parsedResponse) {
            Contact contact = formatedSSNToContact.get(monitoringSetSubjectResponse.id);
            if(contact == null) {
                continue;
            }
            contactsToUpdate.add(handlePersonResponse(monitoringSetSubjectResponse, contact));
        }

        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC) {
    }


    public Contact handlePersonResponse(ValitiveMonitoringSetSubjectResponse response, Contact contact) {
        ValitiveMonitoringSetSubjectResponse.SEPerson person = (ValitiveMonitoringSetSubjectResponse.SEPerson) response.data;


        if(!person.addresses.isEmpty()) {
            for(ValitiveAddress.Address address : person.addresses) {
                if(address.getClassType() != ValitiveAddress.SwedishAddress.class) {
                    continue;
                }

                ValitiveAddress.SwedishAddress se_address = (ValitiveAddress.SwedishAddress) address;

                if(se_address.type != 'SE_NORMALIZED') {
                    continue;
                }
                if(se_address.kind == 'OFFICIAL') {
                    contact.MailingStreet = isSameValue(contact?.MailingStreet, constructAdressSteetString(se_address)) ? contact?.MailingStreet : constructAdressSteetString(se_address);
                    contact.MailingCity = isSameValue(contact?.MailingCity, se_address.city) ? contact?.MailingCity : se_address.city.toUpperCase();
                    contact.MailingState = isSameValue(contact?.MailingState, se_address.county) ? contact?.MailingState : se_address.county;
                    contact.MailingPostalCode = isSameValue(contact?.MailingPostalCode, formatZipCode(se_address.zip)) ? contact?.MailingPostalCode : formatZipCode(se_address.zip);
                    contact.MailingMunicipality__c = isSameValue(contact?.MailingMunicipality__c, se_address.municipality) ? contact?.MailingMunicipality__c : se_address.municipality;
                }
                if(se_address.kind == 'FOREIGN') {
                    contact.Foreign_Address__c = true;
                }
            }
        }
        
        return contact;

    }


    private Boolean isSameValue(String value1, String value2) {
        Boolean result = value1?.toLowerCase() == value2?.toLowerCase();
        return result;  
    }

    private String removeHyphen(String ssn) {
        return ssn.replaceAll('-', '');
    }

    private static String formatZipCode(String zipCode) {
        if (zipCode.length() == 5) {
            return zipCode.substring(0, 3) + ' ' + zipCode.substring(3, 5);
        }
        return zipCode;
    }

    private static String constructAdressSteetString(ValitiveAddress.SwedishAddress address) {
        String street = address.street + ' ' + address.streetNumber;
        if(!String.isBlank(address.numberSuffix)){
            street += address.numberSuffix;
        }
        if (!String.isBlank(address.flat)){
            street += ' lgh ' + address.flat;
        }
        return street;
    }

}