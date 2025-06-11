public class ValitiveEventProcessor implements Queueable, Database.AllowsCallouts {


    private ValitiveService valitiveService;
    private ValitiveUtils valitiveUtils = new ValitiveUtils();

    private Map<String, List<ValitiveMonitoring_Event__e>> eventsMap;
    
    public ValitiveEventProcessor(Map<String, List<ValitiveMonitoring_Event__e>> eventsMap, ValitiveService valitiveService) {
        this.eventsMap = eventsMap;
        this.valitiveService = valitiveService;
    }

    public void execute(QueueableContext context) {

        for (String eventType : eventsMap.keySet()) {
            List<ValitiveMonitoring_Event__e> events = eventsMap.get(eventType);
            switch on eventType {
                when 'AddPerson' {
                    addPersonToMonitorSet(events);
                }
                when 'AddOrg' {
                    addOrgToMonitorSet(events);
                }
            }
        }
    }

    private void addOrgToMonitorSet(List<ValitiveMonitoring_Event__e> events){
        List<Account> accountsToUpdate = new List<Account>();

        for (ValitiveMonitoring_Event__e event : events) {
            String orgNumber = event.Legal_Id__c;
            HttpResponse response = this.valitiveService.bulkAddOrganisationToMonitoringSet(new List<String>{valitiveUtils.removeHyphen(orgNumber)});
            
            Account account = new Account(Id = event.Record_Id__c);

            if (response.getStatusCode() < 400) {
                
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (responseMap.containsKey('processId')) {
                    account.Valitive_Import_Process_Id__c = (String) responseMap.get('processId');
                    account.Valitive_Import_Process_Status__c = 'Pending';
                }
                else {
                    account.IsInMonitoringSet__c = false;
                    account.Valitive_Import_Process_Status__c = 'Failed';
                }
            }
            else {
                account.IsInMonitoringSet__c = false;
                account.Valitive_Import_Process_Status__c = 'Failed';
            }
            accountsToUpdate.add(account);
        }

        if (!accountsToUpdate.isEmpty()) {
            List<Database.SaveResult> result = Database.update(accountsToUpdate, false);
            List<Account> failedAccountUpdates = new List<Account>();
            for (Database.SaveResult sr : result) {
                if (!sr.isSuccess()) {
                    Id accountId = sr.getId();
                    failedAccountUpdates.add(
                        new Account(
                            Id = accountId,
                            IsInMonitoringSet__c = false
                        )
                    );
                }
            }
            if (!failedAccountUpdates.isEmpty()) {
                update failedAccountUpdates;
            }
        }
    }

    private void addPersonToMonitorSet(List<ValitiveMonitoring_Event__e> events){
        List<Contact> contactsToUpdate = new List<Contact>();

        for (ValitiveMonitoring_Event__e event : events) {
            String ssn = event.Legal_Id__c;
            HttpResponse response = this.valitiveService.addPersonToPrivateMonitoringSet(ValitiveUtils.removeHyphen(ssn));
    
            if (response.getStatusCode() < 400) {
                Contact contact = new Contact(Id = event.Record_Id__c);
                contact = (Contact) handleResponse(response, contact);
    
                if (contact != null) {
                    contactsToUpdate.add(contact);
                }
            }
            else {
                Contact contact = new Contact(
                    Id = event.Record_Id__c,
                    IsInMonitoringSet__c = false
                );
                
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            List<Contact> failedContactUpdates = new List<Contact>();
            List<Database.SaveResult> result = Database.update(contactsToUpdate, false);
            for (Database.SaveResult sr : result) {
                if (!sr.isSuccess()) {
                    Id contactId = sr.getId();
                    failedContactUpdates.add(
                        new Contact(
                            Id = contactId,
                            IsInMonitoringSet__c = false
                        )
                    );
                }
            }
            if (!failedContactUpdates.isEmpty()) {
                update failedContactUpdates;
            }
        }
    }




    private SObject handleResponse(HttpResponse response, Contact contact) {

        ValitiveMonitoringSetSubjectResponse parsedResponse = ValitiveMonitoringSetSubjectResponse.parse(response.getBody());

        if (parsedResponse.type == 'PERSON') {
            return handlePersonResponse(parsedResponse, contact);
        }  

        return null;
    }


    public Contact handlePersonResponse(ValitiveMonitoringSetSubjectResponse response, Contact contact) {
        ValitiveMonitoringSetSubjectResponse.SEPerson person = (ValitiveMonitoringSetSubjectResponse.SEPerson) response.data;
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
                    contact.MailingStreet = ValitiveUtils.constructAdressSteetString(se_address);
                    contact.MailingCity = se_address.city.toUpperCase();
                    contact.MailingRegion__c = se_address.county;
                    contact.MailingPostalCode = ValitiveUtils.formatZipCode(se_address.zip);
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
                    contact.MobilePhone = valitiveUtils.formatPhoneNumber(phone);
                }
                if(phone.kind == 'LANDLINE') {
                    contact.Phone = valitiveUtils.formatPhoneNumber(phone);
                }
            }
        }

        contact.IsInMonitoringSet__c = true;

        return contact;

    }
    
}