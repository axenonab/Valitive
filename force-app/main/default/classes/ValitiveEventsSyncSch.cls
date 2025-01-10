public class ValitiveEventsSyncSch implements Schedulable {

    public void execute(SchedulableContext context) {
        Date now = Date.today();
        Date oneWeekAgo = now.addDays(-7);
        Map<String, Object> params = new Map<String, Object>{
            ValitiveQueryParams.ROW_LIMIT => 2000,
            ValitiveQueryParams.DETECTED_ON_OR_AFTER => oneWeekAgo
        };
        System.enqueueJob(new ValitiveEventsSyncQueueable('Private', params));
    }

}