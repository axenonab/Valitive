public class AccountValitiveEventSyncSch implements Schedulable {

        public void execute(SchedulableContext context) {
        AccountValitiveEventSyncBatch batch = new AccountValitiveEventSyncBatch();
        if(!Test.isRunningTest()) {
            Database.executeBatch(batch, 50);
        }
        
    }
}