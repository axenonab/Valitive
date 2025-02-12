public class AddContactToValitiveMonitioringSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    @TestVisible
    private ValitiveService valitiveService = new ValitiveService();

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Personal_Identity_Number__c,
                IsInMonitoringSet__c,
                FirstName,
                LastName,
                MailingStreet,
                MailingCity,
                MailingState, 
                MailingPostalCode,
                MailingMunicipality__c,
                Foreign_Address__c,
                Phone,
                MobilePhone,
                Protected_Identity__c,
                npsp__Deceased__c,
                Deceased_Date__c,
                Has_Trustee__c,
                Has_Trustee_Since__c
            FROM Contact
            WHERE IsInMonitoringSet__c = false
            AND Personal_Identity_Number__c != null
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {

        for (Contact contact : contacts) {
            HttpResponse response = this.valitiveService.addPersonToPrivateMonitoringSet(removeHyphen(contact.Personal_Identity_Number__c));
            if (response.getStatusCode() < 400) {
                handleResponse(response, contact);
            }
        }
        update contacts;
    }

    public void finish(Database.BatchableContext BC) {
    }

    public void handleResponse(HttpResponse response, Contact contact) {
        if (response.getStatusCode() > 400) {
            System.debug('Error: ' + response.getBody());
        }
        ValitiveMonitoringSetSubjectResponse parsedResponse = ValitiveMonitoringSetSubjectResponse.parse(response.getBody());
        if (parsedResponse.type == 'PERSON') {
            handlePersonResponse(parsedResponse, contact);
        }   
    }

    public Contact handlePersonResponse(ValitiveMonitoringSetSubjectResponse response, Contact contact) {
        ValitiveMonitoringSetSubjectResponse.SEPerson person = (ValitiveMonitoringSetSubjectResponse.SEPerson) response.data;

        if (person.guardianShipInfo != null) {
            contact.Has_Trustee__c = true;
            contact.Has_Trustee_Since__c = person.guardianShipInfo.guardedSince;
        }
        if(person.name != null) {
            contact.FirstName = !isSameValue(contact.FirstName, person.name.givenName) ? contact.FirstName : person.name.givenName != null ? person.name.givenName : String.join(person.name.names, ' ');
            contact.LastName = !isSameValue(contact.LastName, person.name.lastName) && person.name.lastName != null ? contact.LastName : person.name.lastName;
        }
        if(person.registrationStatus == 'PROTECTED_ID'){
            contact.Protected_Identity__c = true;
        }
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
                    contact.MailingStreet = !isSameValue(contact?.MailingStreet, constructAdressSteetString(se_address)) ? contact?.MailingStreet : constructAdressSteetString(se_address);
                    contact.MailingCity = !isSameValue(contact?.MailingCity, se_address.city) ? contact?.MailingCity : se_address.city.toUpperCase();
                    contact.MailingState = !isSameValue(contact?.MailingState, se_address.county) ? contact?.MailingState : se_address.county;
                    contact.MailingPostalCode = !isSameValue(contact?.MailingPostalCode, formatZipCode(se_address.zip)) ? contact?.MailingPostalCode : formatZipCode(se_address.zip);
                    contact.MailingMunicipality__c = !isSameValue(contact?.MailingMunicipality__c, se_address.municipality) ? contact?.MailingMunicipality__c : se_address.municipality;
                }
                if(se_address.kind == 'FOREIGN') {
                    contact.Foreign_Address__c = true;
                }
            }
        }
        if(!person.phones.isEmpty()) {
            for(ValitiveMonitoringSetSubjectResponse.PersonalPhone phone : person.phones) {
                if(phone.kind == 'MOBILE') {
                    contact.MobilePhone = formatPhoneNumber(phone);
                }
                if(phone.kind == 'LANDLINE') {
                    contact.Phone = formatPhoneNumber(phone);
                }
            }
        }

        contact.IsInMonitoringSet__c = true;

        return contact;

    }


    private Boolean isSameValue(String value1, String value2) {
        return value1?.toLowerCase() == value2?.toLowerCase();
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

    private static String formatPhoneNumber(ValitiveMonitoringSetSubjectResponse.PersonalPhone phone) {
        String telNumber = phone.telNumber;
        string regexReplace = '^46';
        String formatedNumber = telNumber.replaceAll(regexReplace, '0');
        return formatedNumber;

    }

}