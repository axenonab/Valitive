public class AccountValitiveEventSyncBatch implements Database.Batchable<SObject> {

    private Set<String> accountIdsToProcess = new Set<String>();


    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT
                Id,
                Account__c,
                Type__c,
                Country_Code__c,
                City__c,
                County__c,
                Zip__c,
                Street__c,
                Property_Identifier__c,
                Flat__c,
                Number_Suffix__c,
                Municipality__c,
                Postbox__c,
                Address_Kind__c,
                Org_Status__c,
                Org_Name__c,
                Org_Contact_Legal_Id__c,
                Period__c,
                Duration_In_Months__c,
                New_KPI_Result_Value__c,
                Sync_Status__c,
                Synced_To_Account_At__c
            FROM Valitive_Event__c
            WHERE Sync_Status__c = 'Awaiting Account Sync'
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Valitive_Event__c> events) {
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, List<Valitive_Event__c>> accountEventsMap = mapEventsToAccountIds(events);
        for(Id accountId: accountEventsMap.keySet()){
            List<Valitive_Event__c> accountEvents = accountEventsMap.get(accountId);
            Account updatedAccount = handleAccountEvents(accountId, accountEvents);
            accountsToUpdate.add(updatedAccount);
        }
        doUpdate(accountsToUpdate, accountEventsMap);
    }

    public Valitive_Event__c setSyncStatus(Valitive_Event__c event, String status, List<Database.Error> errors){
        event.Sync_Status__c = status;
        event.Synced_To_Account_At__c = System.now();
        if(!errors.isEmpty()){
            event.Account_Sync_Errors__c = String.join(errors, '\n');
        }
        return event;
    }

    public void doUpdate (List<Account> accountsToUpdate, Map<Id, List<Valitive_Event__c>> accountMap) {
        if(accountsToUpdate.isEmpty()){
            return;
        }
        List<Valitive_Event__c> eventsToUpdate = new List<Valitive_Event__c>();
        List<Database.SaveResult> saveResults = Database.update(accountsToUpdate, false);
        for(Database.SaveResult saveResult: saveResults){
            if(saveResult.isSuccess()){
                List<Valitive_Event__c> relatedEvents = accountMap.get(saveResult.getId());
                for(Valitive_Event__c event : relatedEvents){
                    eventsToUpdate.add(setSyncStatus(event, 'Completed', new List<Database.Error>()));
                }
            } else {
                System.debug(saveResult);
                List<Database.Error> errors = saveResult.getErrors();
                List<Valitive_Event__c> relatedEvents = accountMap.get(saveResult.getId());
                for(Valitive_Event__c event : relatedEvents){
                    eventsToUpdate.add(setSyncStatus(event, 'Failed', errors));
                }
            }
        }
        if(!eventsToUpdate.isEmpty()){
            update eventsToUpdate;
        }
    }


    public Account handleAccountEvents(Id accountId, List<Valitive_Event__c> events){
        Account account = new Account(Id = accountId);
        for(Valitive_Event__c event : events){
            switch on event.Type__c {
                when 'SE_ORG_STATUS_CHANGED' {
                    AccountValitiveEventMapping.mapOrgStatusChangedEventToAccount(account, event);
                }
                when 'SE_ORG_NAME_CHANGED' {
                    AccountValitiveEventMapping.mapOrgNameChangedEventToAccount(account, event);
                }
                when 'SE_ORG_ADDR_CHANGED' {
                    AccountValitiveEventMapping.mapOrgAddrChangedEventToAccount(account, event);
                }
                when 'SE_ORG_ADDR_CORRECTED' {
                    AccountValitiveEventMapping.mapOrgAddrCorrectedEventToAccount(account, event);
                }
                when 'SE_ORG_ARCHIVED' {
                    AccountValitiveEventMapping.mapOrgArchivedEventToAccount(account, event);
                }
                when 'SE_CONTACT_INFO_CHANGED' {
                    // Handled manually
                    continue;
                }
                when 'SE_ORG_KPI_YEAR_RESULT_CHANGED' {
                    AccountValitiveEventMapping.mapOrgKPIResultChangedEventToAccount(account, event);
                }
                when 'SE_BUSINESS_CATEGORY_ADDED' {
                    accountIdsToProcess.add(accountId);
                    
                }
                when 'SE_BUSINESS_CATEGORY_REMOVED' {
                    accountIdsToProcess.add(accountId);
                }
                when else {
                    // Do nothing for unhandled event types
                }
            }
        }
        return account;
    }

    public Map<Id, List<Valitive_Event__c>> mapEventsToAccountIds(List<Valitive_Event__c> events){
        Map<Id, List<Valitive_Event__c>> accountEventsMap = new Map<Id, List<Valitive_Event__c>>();
        for(Valitive_Event__c event : events){
            Id accountId = event.Account__c;
            if(!accountEventsMap.containsKey(accountId)){
                accountEventsMap.put(accountId, new List<Valitive_Event__c>{event});
            } else {
                accountEventsMap.get(accountId).add(event);
            }
        }
        return accountEventsMap;
    }

    public void finish(Database.BatchableContext BC) {
        if(accountIdsToProcess.size() > 0){
            Database.executeBatch(ValitiveQuerySubjectsBatch.withAccountIds(accountIdsToProcess));
        }
    }
}