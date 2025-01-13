@IsTest
private class Test_ContactValitiveEventSyncBatch {
    
    private static String newNameContactLegalId = '19910101-0000';
    private static String deceasedContactLegalId = '19910101-0001';
    private static String phoneBoundContactLegalId = '19910101-0002';
    private static String phoneUnboundContactLegalId = '19910101-0003';
    private static String protectionActivatedContactLegalId = '19910101-0004';
    private static String protectionDeactivatedContactLegalId = '19910101-0005';
    private static String guardActivatedContactLegalId = '19910101-0006';
    private static String guardDeactivatedContactLegalId = '19910101-0007';
    private static String addrChangedContactLegalId = '19910101-0008';
    private static String addrCorrectedContactLegalId = '19910101-0009';


    @TestSetup
    static void makeData(){

        Contact newNameContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = newNameContactLegalId
        );

        Contact newDeceasedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = deceasedContactLegalId
        );

        Contact newPhoneBoundContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = phoneBoundContactLegalId
        );

        Contact newPhoneUnboundContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = phoneUnboundContactLegalId
        );

        Contact newProtectionActivatedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = protectionActivatedContactLegalId,
            Protected_Identity__c = false
        );

        Contact newProtectionDeactivatedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = protectionDeactivatedContactLegalId,
            Protected_Identity__c = true
        );

        Contact newGuardActivatedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = guardActivatedContactLegalId,
            Has_Trustee__c = false,
            Has_Trustee_Since__c = null
        );

        Contact newGuardDeactivatedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = guardDeactivatedContactLegalId,
            Has_Trustee__c = true,
            Has_Trustee_Since__c = Date.today()
        );

        Contact newAddrChangedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = addrChangedContactLegalId
        );

        Contact newAddrCorrectedContact = new Contact(
            FirstName = 'Test',
            LastName = 'Testsson',
            Personal_Identity_Number__c = addrCorrectedContactLegalId
        );
        
        List<Contact> contacts = new List<Contact>{
            newNameContact, 
            newDeceasedContact, 
            newPhoneBoundContact, 
            newPhoneUnboundContact,
            newProtectionActivatedContact, 
            newProtectionDeactivatedContact,
            newGuardActivatedContact, 
            newGuardDeactivatedContact,
            newAddrChangedContact,
            newAddrCorrectedContact
        };
        insert contacts;

        Valitive_Event__c personGuardAddedEvent = new Valitive_Event__c(
            Event_Id__c = '1',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newGuardActivatedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_GUARD_ADDED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Guardianship_Type__c = 'GUARDIANSHIP',
            Guarded_Since__c = Date.today(),
            Contact__c = newGuardActivatedContact.Id
        );

        Valitive_Event__c personGuardRemovedEvent = new Valitive_Event__c(
            Event_Id__c = '2',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newGuardDeactivatedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_GUARD_REMOVED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Contact__c = newGuardDeactivatedContact.Id
        );


        Valitive_Event__c phoneBoundEvent = new Valitive_Event__c(
            Event_Id__c = '9',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newPhoneBoundContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'PHONE_BOUND',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Phone_Kind__c = 'MOBILE',
            Telephone_Number__c = '46760000000',
            Country_Code__c = '46',
            Area_Code__c = '08',
            Registered_Since__c = Date.today(),
            Provider__c = 'TELIA',
            Contact__c = newPhoneBoundContact.Id
        );

        Valitive_Event__c phoneUnboundEvent = new Valitive_Event__c(
            Event_Id__c = '3',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newPhoneUnboundContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'PHONE_UNBOUND',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Phone_Kind__c = 'MOBILE',
            Telephone_Number__c = '46760000000',
            Country_Code__c = '46',
            Area_Code__c = '08',
            Provider__c = 'TELIA',
            Contact__c = newPhoneUnboundContact.Id
        );

        Valitive_Event__c personProtectionActivatedEvent = new Valitive_Event__c(
            Event_Id__c = '4',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newProtectionActivatedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'PERSON_PROTECTION_ACTIVATED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Since__c = Date.today(),
            Contact__c = newProtectionActivatedContact.Id
        );

        Valitive_Event__c personProtectionDeactivatedEvent = new Valitive_Event__c(
            Event_Id__c = '5',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newProtectionDeactivatedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'PERSON_PROTECTION_DEACTIVATED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Since__c = Date.today(),
            Contact__c = newProtectionDeactivatedContact.Id
        );

        Valitive_Event__c personDeceasedEvent = new Valitive_Event__c(
            Event_Id__c = '123',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newDeceasedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_PERSON_DECEASED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Deceased_On__c = Date.today(),
            Deceased_On_Month__c = '2024-02',
            Deceased_On_Year__c = 2024,
            Contact__c = newDeceasedContact.Id
        );

        Valitive_Event__c personAddrChangedEvent = new Valitive_Event__c(
            Event_Id__c = '6',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newAddrChangedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_PERSON_ADDR_CHANGED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Address_Type__c = 'SE_NORMALIZED',
            Address_Kind__c = 'OFFICIAL',
            Country__c = 'Sweden',
            County__c = 'Stockholms län',
            City__c = 'STOCKHOLM',
            Zip__c = '12345',
            Street__c = 'Testgatan Changed',
            Property_Identifier__c = '1',
            Flat__c = '1',
            Municipality__c = 'Stockholm',
            Contact__c = newAddrChangedContact.Id
        );

        Valitive_Event__c personAddrCorrectedEvent = new Valitive_Event__c(
            Event_Id__c = '7',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newAddrCorrectedContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_PERSON_ADDR_CORRECTED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Address_Type__c = 'SE_NORMALIZED',
            Address_Kind__c = 'OFFICIAL',
            Country__c = 'Sweden',
            County__c = 'Stockholms län',
            City__c = 'STOCKHOLM',
            Zip__c = '12345',
            Street__c = 'Testgatan Corrected',
            Property_Identifier__c = '1',
            Flat__c = '1',
            Municipality__c = 'Stockholm',
            Contact__c = newAddrCorrectedContact.Id
        );

        Valitive_Event__c personNameChangeEvent = new Valitive_Event__c(
            Event_Id__c = '8',
            Detected_At__c = Datetime.now(),
            Person_Legal_Id__c = newNameContact.Personal_Identity_Number__c.replace('-', ''),
            Type__c = 'SE_PERSON_NAME_CHANGED',
            Person_Id__c = '1',
            Timestamp__c = Datetime.now(),
            Given_Name__c = 'New Test',
            FirstName__c = 'New Test Test',
            LastName__c = 'New Testsson',
            Valid_Since__c = Date.today(),
            Contact__c = newNameContact.Id
        );

        List<Valitive_Event__c> events = new List<Valitive_Event__c>{
            personGuardAddedEvent,
            personGuardRemovedEvent,
            phoneBoundEvent,
            phoneUnboundEvent,
            personProtectionActivatedEvent,
            personProtectionDeactivatedEvent,
            personDeceasedEvent,
            personAddrChangedEvent,
            personAddrCorrectedEvent,
            personNameChangeEvent
        };

        insert events;
    }

    @IsTest
    static void should_update_contact_name(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT FirstName, LastName FROM Contact WHERE Personal_Identity_Number__c = :newNameContactLegalId];
        System.assertEquals('New Test', contact.FirstName);
        System.assertEquals('New Testsson', contact.LastName);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_PERSON_NAME_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_contact_deceased(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT npsp__Deceased__c, Deceased_Date__c FROM Contact WHERE Personal_Identity_Number__c = :deceasedContactLegalId];
        System.assertEquals(true, contact.npsp__Deceased__c);
        System.assertEquals(Date.today(), contact.Deceased_Date__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_PERSON_DECEASED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_contact_phone_bound(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT Phone, MobilePhone FROM Contact WHERE Personal_Identity_Number__c = :phoneBoundContactLegalId];
        System.assertEquals('0760000000', contact.MobilePhone);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'PHONE_BOUND'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_person_addr_changed(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT MailingStreet, MailingCity, MailingCountry, MailingPostalCode FROM Contact WHERE Personal_Identity_Number__c = :addrChangedContactLegalId];
        System.assertEquals('Testgatan Changed 1 lgh 1', contact.MailingStreet);
        System.assertEquals('STOCKHOLM', contact.MailingCity);
        // System.assertEquals('Sweden', contact.MailingCountry);
        System.assertEquals('123 45', contact.MailingPostalCode);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_PERSON_ADDR_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_person_addr_corrected(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT MailingStreet, MailingCity, MailingCountry, MailingPostalCode FROM Contact WHERE Personal_Identity_Number__c = :addrCorrectedContactLegalId];
        System.assertEquals('Testgatan Corrected 1 lgh 1', contact.MailingStreet);
        System.assertEquals('STOCKHOLM', contact.MailingCity);
        // System.assertEquals('Sweden', contact.MailingCountry);
        System.assertEquals('123 45', contact.MailingPostalCode);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_PERSON_ADDR_CORRECTED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_person_protection_activated(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT Protected_Identity__c FROM Contact WHERE Personal_Identity_Number__c = :protectionActivatedContactLegalId];
        System.assertEquals(true, contact.Protected_Identity__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'PERSON_PROTECTION_ACTIVATED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_person_protection_deactivated(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT Protected_Identity__c FROM Contact WHERE Personal_Identity_Number__c = :protectionDeactivatedContactLegalId];
        System.assertEquals(false, contact.Protected_Identity__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'PERSON_PROTECTION_DEACTIVATED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_person_guard_added(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT Has_Trustee__c, Has_Trustee_Since__c FROM Contact WHERE Personal_Identity_Number__c = :guardActivatedContactLegalId];
        System.assertEquals(true, contact.Has_Trustee__c);
        System.assertEquals(Date.today(), contact.Has_Trustee_Since__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_GUARD_ADDED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_person_guard_removed(){
        Test.startTest();
        Database.executeBatch(new ContactValitiveEventSyncBatch());
        Test.stopTest();
        Contact contact = [SELECT Has_Trustee__c, Has_Trustee_Since__c FROM Contact WHERE Personal_Identity_Number__c = :guardDeactivatedContactLegalId];
        System.assertEquals(false, contact.Has_Trustee__c);
        System.assertEquals(null, contact.Has_Trustee_Since__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_GUARD_REMOVED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }


}