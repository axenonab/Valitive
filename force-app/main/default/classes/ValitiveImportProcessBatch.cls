

public class ValitiveImportProcessBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {


    @TestVisible
    private final ValitiveService valitiveService = new ValitiveService();


    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT 
                Id,
                Valitive_Import_Process_Id__c,
                Valitive_Import_Process_Status__c
            FROM Account 
            WHERE 
                Valitive_Import_Process_Status__c = 'Pending'
        ]);
    }

    public void execute(Database.BatchableContext BC, List<Account> accounts) {

        List<Database.SaveResult> results = new List<Database.SaveResult>();
        List<Account> accountsToUpdate = new List<Account>();

        for (Account account : accounts) {
            HttpResponse response = valitiveService.getImportProcessStatus(account.Valitive_Import_Process_Id__c);
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String status = (String) responseMap.get('status');
                switch on status {
                    when 'COMPLETED' {
                        account.Valitive_Import_Process_Status__c = 'Awaiting Initial Sync';
                    }
                    when 'STALLED' {
                        account.Valitive_Import_Process_Status__c = 'Failed';
                    }
                }
            } 
            accountsToUpdate.add(account);
        }

        if (!accountsToUpdate.isEmpty()) {
            results = Database.update(accountsToUpdate, false);
        }

    }

    public void finish(Database.BatchableContext BC) {
    }

}
