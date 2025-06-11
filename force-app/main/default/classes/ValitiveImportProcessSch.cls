public class ValitiveImportProcessSch implements Schedulable {

    public void execute(SchedulableContext SC) {
        ValitiveImportProcessBatch batch = new ValitiveImportProcessBatch();
        if(!Test.isRunningTest()) {
            Database.executeBatch(batch, 50);        }
        
    }

}