
public class ValitiveQuerySubjectsSch implements Schedulable {

    public void execute(SchedulableContext SC) {
        // Execute the batch class to query subjects

        Database.executeBatch(new ValitiveQuerySubjectsBatch('Awaiting Initial Sync'), 50);
        
    }

}