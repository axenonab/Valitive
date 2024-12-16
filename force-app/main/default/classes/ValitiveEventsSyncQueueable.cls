public class ValitiveEventsSyncQueueable implements Queueable, Database.AllowsCallouts {

    private String entity;
    private String nextPage;
    private Map<String, Object> params;
    private final ValitiveServices service = new ValitiveServices();

    // Constructor for syncing by entity with optional parameters
    public ValitiveEventsSyncQueueable(String entity, Map<String, Object> params) {
        this.entity = entity;
        this.params = params.isEmpty() ? null : params;
    }

    // Constructor for syncing by entity only
    public ValitiveEventsSyncQueueable(String entity) {
        this(entity, new Map<String, Object>());
    }

    // Constructor for syncing by next page
    public ValitiveEventsSyncQueueable(String nextPage, Boolean isNextPage) {
        if (isNextPage) {
            this.nextPage = nextPage;
        }
    }

    // Setter for parameters
    public void setParams(Map<String, Object> params) {
        this.params = params;
    }

    // Execute method for queueable processing
    public void execute(QueueableContext context) {
        // Ensure valid input
        if (this.entity == null && this.nextPage == null) {
            System.debug('No entity or nextPage provided. Exiting.');
            return;
        }

        HttpResponse response;

        try {
            // Sync based on nextPage or entity
            if (this.nextPage != null) {
                response = service.syncEvents(this.nextPage);
            } else {
                response = service.syncEvents(this.entity, this.params);
            }

            // Handle non-200 status codes
            if (response.getStatusCode() != 200) {
                System.debug('Error syncing events: ' + response.getStatusCode() + ' - ' + response.getBody());
                return;
            }

            // Process the response
            ValitiveResponseHandler.handleEventsResponse(response);

            // Check for next page and enqueue if available
            if (service.hasNextPage(response)) {
                String nextIterator = service.getNextPage(response);
                if (!Test.isRunningTest()) {
                    ValitiveEventsSyncQueueable nextSync = new ValitiveEventsSyncQueueable(nextIterator, true);
                    System.enqueueJob(nextSync);
                }
            }
        } catch (Exception e) {
            System.debug('Exception during event sync: ' + e.getMessage());
        }
    }
}