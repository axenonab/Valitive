public class ValitiveOrgEventsSyncSch implements Schedulable {

    private static final List<String> EVENT_TYPES = new List<String>{
        'SE_ORG_STATUS_CHANGED', 
        'SE_ORG_NAME_CHANGED', 
        'SE_ORG_ADDR_CHANGED', 
        'SE_ORG_ADDR_CORRECTED', 
        'SE_ORG_ARCHIVED', 
        'SE_CONTACT_INFO_CHANGED', 
        'SE_ORG_KPI_YEAR_RESULT_CHANGED', 
        'SE_BUSINESS_CATEGORY_ADDED', 
        'SE_BUSINESS_CATEGORY_REMOVED'
    };

    public void execute(SchedulableContext context) {
        Date now = Date.today();
        Date oneWeekAgo = now.addDays(-7);
        Datetime dt = Datetime.newInstanceGMT(oneWeekAgo.year(), oneWeekAgo.month(), oneWeekAgo.day(), 0, 0, 0);
        String formatedDt = dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        Map<String, Object> params = new Map<String, Object>{
            ValitiveQueryParams.ROW_LIMIT => 2000,
            ValitiveQueryParams.DETECTED_ON_OR_AFTER => formatedDt,
            ValitiveQueryParams.EVENT_TYPES => String.join(EVENT_TYPES, ',')
        };
        if(!Test.isRunningTest()) {
            System.enqueueJob(new ValitiveEventsSyncQueueable('Organisation', params));
        }
    }

}