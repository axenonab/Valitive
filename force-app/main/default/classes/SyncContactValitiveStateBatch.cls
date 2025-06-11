public class SyncContactValitiveStateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {


    @TestVisible
    private ValitiveService valitiveService = new ValitiveService();
    private ValitiveUtils valitiveUtils = new ValitiveUtils();

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Personal_Identity_Number__c, 
                MailingStreet,
                MailingCity,
                MailingRegion__c, 
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
            formatedSSNToContact.put(valitiveUtils.removeHyphen(contact.Personal_Identity_Number__c), contact);
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
                    contact.MailingStreet = valitiveUtils.isSameValue(contact?.MailingStreet, valitiveUtils.constructAdressSteetString(se_address)) ? contact?.MailingStreet : valitiveUtils.constructAdressSteetString(se_address);
                    contact.MailingCity = valitiveUtils.isSameValue(contact?.MailingCity, se_address.city) ? contact?.MailingCity : se_address.city.toUpperCase();
                    contact.MailingRegion__c = valitiveUtils.isSameValue(contact?.MailingRegion__c, se_address.county) ? contact?.MailingRegion__c : se_address.county;
                    contact.MailingPostalCode = valitiveUtils.isSameValue(contact?.MailingPostalCode, valitiveUtils.formatZipCode(se_address.zip)) ? contact?.MailingPostalCode : valitiveUtils.formatZipCode(se_address.zip);
                    contact.MailingMunicipality__c = valitiveUtils.isSameValue(contact?.MailingMunicipality__c, se_address.municipality) ? contact?.MailingMunicipality__c : se_address.municipality;
                }
                if(se_address.kind == 'FOREIGN') {
                    contact.Foreign_Address__c = true;
                }
            }
        }
        
        return contact;

    }

}