@IsTest
public class Test_AccountValitiveEventSyncBatch {

    private static String orgStatusChangedAccountLegalId = '555555-5551';
    private static String newNameAccountLegalId = '555555-5552';
    private static String addressChangedAccountLegalId = '555555-5553';
    private static String addressCorrectedAccountLegalId = '555555-5554';
    private static String orgArchivedAccountLegalId = '555555-5555';
    private static String contactInfoChangedAccountLegalId = '555555-5556';
    private static String orgKpiChangedAccountLegalId = '555555-5557';
    private static String orgBusinessCategoryAddedAccountLegalId = '555555-5558';
    private static String orgBusinessCategoryRemovedAccountLegalId = '555555-5559';
    

    @TestSetup
    static void makeData(){
        Account newStatusAccount = new Account(
            Name = 'Status Changed Account',
            Company_Number__c = orgStatusChangedAccountLegalId
        );
        
        Account newNameAccount = new Account(
            Name = 'Name Changed Account',
            Company_Number__c = newNameAccountLegalId
        );

        Account addressChangedAccount = new Account(
            Name = 'Address Changed Account',
            Company_Number__c = addressChangedAccountLegalId
        );

        Account addressCorrectedAccount = new Account(
            Name = 'Address Corrected Account',
            Company_Number__c = addressCorrectedAccountLegalId
        );

        Account contactInfoChangedAccount = new Account(
            Name = 'Contact Info Changed Account',
            Company_Number__c = contactInfoChangedAccountLegalId
        );

        Contact contactInfoChangedContact = new Contact(
            FirstName = 'Contact',
            LastName = 'InfoChanged',
            Personal_Identity_Number__c = '19850522-9846'
        );

        Account orgArchivedAccount = new Account(
            Name = 'Org Archived Account',
            Company_Number__c = orgArchivedAccountLegalId
        );

        Account orgKpiChangedAccount = new Account(
            Name = 'Org KPI Changed Account',
            Company_Number__c = orgKpiChangedAccountLegalId
        );

        Account orgBusinessCategoryAddedAccount = new Account(
            Name = 'Org Business Category Added Account',
            Company_Number__c = orgBusinessCategoryAddedAccountLegalId
        );

        Account orgBusinessCategoryRemovedAccount = new Account(
            Name = 'Org Business Category Removed Account',
            Company_Number__c = orgBusinessCategoryRemovedAccountLegalId
        );

        Contact contactInfoChanged = new Contact(
            FirstName = 'Contact',
            LastName = 'InfoChanged',
            Personal_Identity_Number__c = '19900101-1234'
        );

        List<Account> accountsToInsert = new List<Account>{
            newStatusAccount,
            newNameAccount,
            addressChangedAccount,
            addressCorrectedAccount,
            contactInfoChangedAccount,
            orgArchivedAccount,
            orgKpiChangedAccount,
            orgBusinessCategoryAddedAccount,
            orgBusinessCategoryRemovedAccount
        };
        insert accountsToInsert;
        insert contactInfoChanged;

        Valitive_Event__c statusChangedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-001',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = newStatusAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_STATUS_CHANGED',
            Timestamp__c = Datetime.now(),
            Org_Status__c = 'ACTIVE',
            Old_Org_Status__c = 'INACTIVE',
            Account__c = newStatusAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c nameChangedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-002',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = newNameAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_NAME_CHANGED',
            Timestamp__c = Datetime.now(),
            Org_Name__c = 'New Organization Name Inc.',
            Old_Org_Name__c = 'Old Organization Name LLC',
            Account__c = newNameAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c addressChangedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-003',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = addressChangedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_ADDR_CHANGED',
            Timestamp__c = Datetime.now(),
            Address_Kind__c = 'MAIL',
            Country_Code__c = 'SE',
            City__c = 'STOCKHOLM',
            County__c = 'STOCKHOLMS LÄN',
            Zip__c = '12345',
            Street__c = 'New Street',
            Property_Identifier__c = '1',
            Account__c = addressChangedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c addressCorrectedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-004',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = addressCorrectedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_ADDR_CORRECTED',
            Timestamp__c = Datetime.now(),
            Address_Kind__c = 'MAIL',
            Country_Code__c = 'SE',
            City__c = 'GOTHENBURG',
            County__c = 'VÄSTRA GÖTALANDS LÄN',
            Zip__c = '54321',
            Street__c = 'Corrected Street',
            Property_Identifier__c = '2',
            Account__c = addressCorrectedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c orgArchivedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-005',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = orgArchivedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_ARCHIVED',
            Timestamp__c = Datetime.now(),
            Account__c = orgArchivedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c contactInfoChangedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-006',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = contactInfoChangedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_CONTACT_INFO_CHANGED',
            Timestamp__c = Datetime.now(),
            Org_Contact_Legal_Id__c = '199001011234',
            Account__c = contactInfoChangedAccount.Id,
            Sync_Status__c = 'Awaiting Manual Review'
        );

        Valitive_Event__c KpiResultChangedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-007',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = orgKpiChangedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_ORG_KPI_YEAR_RESULT_CHANGED',
            Timestamp__c = Datetime.now(),
            Period__c = Date.today(),
            Duration_In_Months__c = 12,
            New_KPI_Result_Value__c = 100000.00,
            Account__c = orgKpiChangedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c businessCategoryAddedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-008',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = orgBusinessCategoryAddedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_BUSINESS_CATEGORY_ADDED',
            Timestamp__c = Datetime.now(),
            Account__c = orgBusinessCategoryAddedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        Valitive_Event__c businessCategoryRemovedEvent = new Valitive_Event__c(
            Event_Id__c = 'event-009',
            Detected_At__c = Datetime.now(),
            Organization_Legal_Id__c = orgBusinessCategoryRemovedAccount.Company_Number__c.replace('-', ''),
            Type__c = 'SE_BUSINESS_CATEGORY_REMOVED',
            Timestamp__c = Datetime.now(),
            Account__c = orgBusinessCategoryRemovedAccount.Id,
            Sync_Status__c = 'Awaiting Account Sync'
        );

        List<Valitive_Event__c> eventsToInsert = new List<Valitive_Event__c>{
            statusChangedEvent,
            nameChangedEvent,
            addressChangedEvent,
            addressCorrectedEvent,
            orgArchivedEvent,
            contactInfoChangedEvent,
            KpiResultChangedEvent,
            businessCategoryAddedEvent,
            businessCategoryRemovedEvent
        };
        insert eventsToInsert;

    }

    @IsTest
    static void should_update_account_name(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT Name FROM Account WHERE Company_Number__c = :newNameAccountLegalId LIMIT 1];
        System.assertEquals('New Organization Name Inc.', account.Name);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_NAME_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_account_status(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT Status__c FROM Account WHERE Company_Number__c = :orgStatusChangedAccountLegalId LIMIT 1];
        System.assertEquals('ACTIVE', account.Status__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_STATUS_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_account_address(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT BillingStreet, BillingCity, BillingPostalCode FROM Account WHERE Company_Number__c = :addressChangedAccountLegalId LIMIT 1];
        System.assertEquals('New Street 1', account.BillingStreet);
        System.assertEquals('STOCKHOLM', account.BillingCity);
        System.assertEquals('123 45', account.BillingPostalCode);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_ADDR_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_account_address_corrected(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT BillingStreet, BillingCity, BillingPostalCode FROM Account WHERE Company_Number__c = :addressCorrectedAccountLegalId LIMIT 1];
        System.assertEquals('Corrected Street 2', account.BillingStreet);
        System.assertEquals('GOTHENBURG', account.BillingCity);
        System.assertEquals('543 21', account.BillingPostalCode);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_ADDR_CORRECTED'];
        System.assertEquals('Completed', event.Sync_Status__c);

    }

    @IsTest
    static void should_update_account_archived(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT IsInMonitoringSet__c, Exclude_From_Monitoring_Set__c FROM Account WHERE Company_Number__c = :orgArchivedAccountLegalId LIMIT 1];
        System.assertEquals(false, account.IsInMonitoringSet__c);
        System.assertEquals(true, account.Exclude_From_Monitoring_Set__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_ARCHIVED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_account_contact_info(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_CONTACT_INFO_CHANGED'];
        System.assertEquals('Awaiting Manual Review', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_account_kpi_year_result(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Account account = [SELECT Latest_Year_Result__c FROM Account WHERE Company_Number__c = :orgKpiChangedAccountLegalId LIMIT 1];
        System.assertEquals(100000.00, account.Latest_Year_Result__c);
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_ORG_KPI_YEAR_RESULT_CHANGED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_business_category_added_event(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_BUSINESS_CATEGORY_ADDED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

    @IsTest
    static void should_update_business_category_removed_event(){
        Test.startTest();
        Database.executeBatch(new AccountValitiveEventSyncBatch());
        Test.stopTest();
        Valitive_Event__c event = [SELECT Sync_Status__c FROM Valitive_Event__c WHERE Type__c = 'SE_BUSINESS_CATEGORY_REMOVED'];
        System.assertEquals('Completed', event.Sync_Status__c);
    }

}