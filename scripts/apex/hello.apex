// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

ValitivePropertiesProvider valitivePropertiesProvider = new ValitivePropertiesProvider();
ValitiveClient valitiveClient = new ValitiveClient(valitivePropertiesProvider);
ValitiveServices valitiveServices = new ValitiveServices(valitiveClient);
HttpResponse response = valitiveServices.syncEvents('Private');

