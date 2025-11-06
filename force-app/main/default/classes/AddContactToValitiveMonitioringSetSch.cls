public class AddContactToValitiveMonitioringSetSch implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        AddContactToValitiveMonitioringSetBatch batch = new AddContactToValitiveMonitioringSetBatch();
        Database.executeBatch(batch, 200);
    }
    
}