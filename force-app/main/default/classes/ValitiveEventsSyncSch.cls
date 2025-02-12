public class ValitiveEventsSyncSch implements Schedulable {

    public void execute(SchedulableContext context) {
        Date now = Date.today();
        Date oneWeekAgo = now.addDays(-7);
        Datetime dt = Datetime.newInstanceGMT(oneWeekAgo.year(), oneWeekAgo.month(), oneWeekAgo.day(), 0, 0, 0);
        String formatedDt = dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Map<String, Object> params = new Map<String, Object>{
            ValitiveQueryParams.ROW_LIMIT => 2000,
            ValitiveQueryParams.DETECTED_ON_OR_AFTER => formatedDt
        };
        if(!Test.isRunningTest()) {
            System.enqueueJob(new ValitiveEventsSyncQueueable('Private', params));
        }
    }

}