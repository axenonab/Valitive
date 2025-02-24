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

Object test = '2025';
System.debug(SON.deserialize(JSON.serialize(test), Integer.class));