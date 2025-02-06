// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents


// ValitiveService valitiveService = new ValitiveService();
// HttpResponse response = valitiveService.syncEvents('Private', null);
// Map<String, Object> params = new Map<String, Object>{
//     ValitiveQueryParams.ROW_LIMIT => 700
// };
// ValitiveEventsSyncQueueable queueable = new ValitiveEventsSyncQueueable('Private', params);

// System.enqueueJob(queueable);

// String endpoint = 'https://mock.valitive.com/pub/api/v1/monitoring-set/mock-private-id/events?limit=700';

// // Split the URL at the "?" and take the part before it
// if (endpoint.contains('?')) {
//     endpoint = endpoint.split('\\?')[0];
// }

// System.debug('Base URL: ' + endpoint); // Outputs: https://mock.valitive.com/pub/api/v1/monitoring-set/mock-private-id/events

Database.executeBatch(new AddContactToValitiveMonitioringSetBatch());