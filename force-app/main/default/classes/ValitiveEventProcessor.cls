public class ValitiveEventProcessor implements Queueable, Database.AllowsCallouts {


    private ValitiveService valitiveService;

    private Map<String, List<ValitiveMonitoring_Event__e>> eventsMap;
    
    public ValitiveEventProcessor(Map<String, List<ValitiveMonitoring_Event__e>> eventsMap, ValitiveService valitiveService) {
        this.eventsMap = eventsMap;
        this.valitiveService = valitiveService;
    }

    public void execute(QueueableContext context) {
        System.debug('Executing ValitiveEventProcessor');
        System.debug('Events: ' + eventsMap);
        for (String eventType : eventsMap.keySet()) {
            List<ValitiveMonitoring_Event__e> events = eventsMap.get(eventType);
            switch on eventType {
                when 'AddPerson' {
                    addPersonToMonitorSet(events);
                }
            }
        }
    }

    private void addPersonToMonitorSet(List<ValitiveMonitoring_Event__e> events){
        List<Contact> contactsToUpdate = new List<Contact>();

        for (ValitiveMonitoring_Event__e event : events) {
            String ssn = event.Personal_Identity_Number__c;
            HttpResponse response = this.valitiveService.addPersonToPrivateMonitoringSet(removeHyphen(ssn));
    
            if (response.getStatusCode() < 400) {
                Contact contact = new Contact(Id = event.Record_Id__c);
                contact = (Contact) handleResponse(response, contact);
    
                if (contact != null) {
                    contactsToUpdate.add(contact);
                }
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }



    private SObject handleResponse(HttpResponse response, Contact contact) {
        if (response.getStatusCode() > 400) {
            System.debug('Error: ' + response.getBody());
            return null;
        }
        ValitiveMonitoringSetSubjectResponse parsedResponse = ValitiveMonitoringSetSubjectResponse.parse(response.getBody());
        if (parsedResponse.type == 'PERSON') {
            return handlePersonResponse(parsedResponse, contact);
        }   
        return null;
    }

    public Contact handlePersonResponse(ValitiveMonitoringSetSubjectResponse response, Contact contact) {
        ValitiveMonitoringSetSubjectResponse.SEPerson person = (ValitiveMonitoringSetSubjectResponse.SEPerson) response.data;
        System.debug('Person: ' + person);
        if (person.guardianShipInfo != null) {
            contact.Has_Trustee__c = true;
            contact.Has_Trustee_Since__c = person.guardianShipInfo.guardedSince;
        }
        if(person.name != null) {
            contact.FirstName = person.name.givenName != null ? person.name.givenName : String.join(person.name.names, ' ');
            contact.LastName = person.name.lastName;
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
                    contact.MailingStreet = constructAdressSteetString(se_address);
                    contact.MailingCity = se_address.city.toUpperCase();
                    contact.MailingState = se_address.county;
                    contact.MailingPostalCode = formatZipCode(se_address.zip);
                    contact.MailingMunicipality__c = se_address.municipality;
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