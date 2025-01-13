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

String zipCode = '12345';
System.debug('zipCode: ' + zipCode.length());
System.debug(zipCode.substring(0, 2) + ' ' + zipCode.substring(2, 5));