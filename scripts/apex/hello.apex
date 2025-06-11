// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents


// ValitiveService valitiveService = new ValitiveService();
// Map<String, Object> params = new Map<String, Object>{
//     ValitiveQueryParams.ROW_LIMIT => 3000,
//     ValitiveQueryParams.EVENT_TYPES => 'SE_PERSON_ADDR_CHANGED',
//     ValitiveQueryParams.DETECTED_ON_OR_AFTER => '2021-01-20T00:00:00Z'
// };

// System.enqueueJob(new ValitiveEventsSyncQueueable('Private', params));
// HttpResponse res = valitiveService.syncEvents('Private', params);

// ValitiveResponseHandler.handleEventsResponse(res);


// ValitiveService valitiveService = new ValitiveService();
// Set<String> formatedSSNToContact = new Set<String>{
//     '5560495649'
// };

// Map<String, String> queryParams = new Map<String, String> {
//     ValitiveQueryParams.IDS => String.join(formatedSSNToContact, ','),
//     ValitiveQueryParams.MONITORING_SET_IDS => valitiveService.getOrganisationMonitoringSetId(),
//     ValitiveQueryParams.ROW_LIMIT => '1000'
// };

// HttpResponse response = valitiveService.queryMonitoringSetScope(queryParams);
// List<ValitiveMonitoringSetSubjectResponse> result = ValitiveMonitoringSetSubjectResponse.parseList(response.getBody());
// System.debug(result);

// Database.executeBatch(new ValitiveImportProcessBatch());
// Database.executeBatch(new ValitiveQuerySubjectsBatch('Awaiting Initial Sync'));
// ValitivePropertiesProvider valitivePropertiesProvider = new ValitivePropertiesProvider();
// ValitiveClient valitiveClient = new ValitiveClient(valitivePropertiesProvider);
// System.debug(valitiveClient.fetchAccessToken());

String a = null;
String result = a?.equalsIgnoreCase('b') ? 'true' : 'false';
System.debug(result);