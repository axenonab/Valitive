trigger ValitiveMonitoringEventTrigger on ValitiveMonitoring_Event__e (after insert) {

    Map<String, List<ValitiveMonitoring_Event__e>> eventMap = valitivegroupEventsByAction(Trigger.new);

    ValitiveEventProcessor eventProcessor;

    if (Test.isRunningTest()) {
        // Inject the mock provider into the service during tests
        MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
        ValitiveService mockService = new ValitiveService(mockProvider);

        // Pass the mock service to the processor
        eventProcessor = new ValitiveEventProcessor(eventMap, mockService);
    } else {
        // Use the default service in production
        eventProcessor = new ValitiveEventProcessor(eventMap, new ValitiveService());
    }
    System.enqueueJob(eventProcessor);



    private Map<String, List<ValitiveMonitoring_Event__e>> valitivegroupEventsByAction(List<ValitiveMonitoring_Event__e> events){
        Map<String, List<ValitiveMonitoring_Event__e>> groupedEvents = new Map<String, List<ValitiveMonitoring_Event__e>>();
        for(ValitiveMonitoring_Event__e event : events){
            if(!groupedEvents.containsKey(event.Action__c)){
                groupedEvents.put(event.Action__c, new List<ValitiveMonitoring_Event__e>());
            }
            groupedEvents.get(event.Action__c).add(event);
        }
        return groupedEvents;
    }
}