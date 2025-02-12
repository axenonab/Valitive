public class ContactValitiveEventSyncSch implements Schedulable{
    
    public void execute(SchedulableContext context) {
        ContactValitiveEventSyncBatch batch = new ContactValitiveEventSyncBatch();
        if(!Test.isRunningTest()) {
            Database.executeBatch(batch, 50);
        }
        
    }

}