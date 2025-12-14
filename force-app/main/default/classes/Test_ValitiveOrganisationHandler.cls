@IsTest
private class Test_ValitiveOrganisationHandler {

    @IsTest
    static void testHandleOrgResponse_SEOrganization() {

        /*String json = ''
            + '{'
            + '  "_type": "ORGANIZATION",'
            + '  "id": "9947009438",'
            + '  "monitoringSetId": "bbaf3ad374f54893812bc9c194cc2db1",'
            + '  "addedAt": "2025-11-13T14:56:29.102Z",'
            + '  "updatedAt": "2025-11-13T14:56:29.102Z",'
            + '  "data": {'
            + '    "_type": "SE_ORGANIZATION",'
            + '    "id": "CAISFjRVY3Bzb3RyU1FPWWhucHphbUlJU3c",'
            + '    "country": "SE",'
            + '    "legalId": "9947009438",'
            + '    "names": [{'
            + '      "name": "Advokatbyrån Kaiding KB",'
            + '      "rawName": "Advokatbyrån Kaiding Kommanditbolag",'
            + '      "kind": "OFFICIAL"'
            + '    }],'
            + '    "addresses": [{'
            + '      "_type": "SE_NORMALIZED",'
            + '      "kind": "MAIL",'
            + '      "country": "SE",'
            + '      "street": "Kanalgatan",'
            + '      "number": "59",'
            + '      "zip": "93132",'
            + '      "city": "Skellefteå",'
            + '      "county": "Västerbotten",'
            + '      "municipality": "Skellefteå"'
            + '    }],'
            + '    "emails": ["skelleftea@kaiding.se"],'
            + '    "phones": [{"type": "MAIN", "number": "0910-12345"}],'
            + '    "urls": ["https://www.kaiding.se"],'
            + '    "businessDescription": "Advokatrörelse.",'
            + '    "primaryIndustry": {'
            + '      "primary": {'
            + '        "_type": "NORDIC_INDUSTRY",'
            + '        "description": "Advokatbyråverksamhet",'
            + '        "standardName": "SNI",'
            + '        "code": "69101"'
            + '      },'
            + '      "altClassifications": [{'
            + '        "_type": "NORDIC_INDUSTRY",'
            + '        "description": "Legal activities",'
            + '        "standardName": "NACE",'
            + '        "code": "6910"'
            + '      }]'
            + '    },'
            + '    "statusInfo": {'
            + '      "_type": "SE_STATUS_INFO",'
            + '      "status": "ACTIVE"'
            + '    },'
            + '    "incorpDate": "2009-07-06",'
            + '    "legalForm": {'
            + '      "code": "KB",'
            + '      "name": "Kommanditbolag"'
            + '    },'
            + '    "employmentHistory": [{'
            + '      "date": "2022-02-17",'
            + '      "period": "MONTHLY",'
            + '      "count": 0,'
            + '      "interval": {'
            + '        "min": 0,'
            + '        "max": 0'
            + '      }'
            + '    }]'
            + '  }'
            + '}'
        ;*/

        MockValitivePropertiesProvider mockProvider = MockValitivePropertiesProvider.createMockProvider();
        ValitiveClientMock mock = new ValitiveClientMock(mockProvider);
        mock.buildMockServer();
        mock.addOrgQueryResponse();
        mock.addImportRequestPresponse();
        Test.setMock(HttpCalloutMock.class, mock.mockServer);

        ValitiveMonitoringSetSubjectResponse response = (ValitiveMonitoringSetSubjectResponse) JSON.deserialize(json, ValitiveMonitoringSetSubjectResponse.class);

        Account account = new Account();

        /* ============================================================
           2. Act
           ============================================================ */

        Test.startTest();
        account = new ValitiveQuerySubjectsBatch().handleOrgResponse(response, account);
        Test.stopTest();

        /* ============================================================
           3. Assert – Core fields
           ============================================================ */

        System.assertEquals(
            'Advokatbyrån Kaiding KB',
            account.Name,
            'Account Name should come from OFFICIAL name'
        );

        System.assertEquals(
            'Advokatrörelse.',
            account.Description,
            'Business description should be mapped'
        );

        System.assertEquals(
            Date.newInstance(2009, 7, 6),
            account.Established__c,
            'Incorporation date should be mapped'
        );

        System.assertEquals(
            2009,
            account.Year_Established__c,
            'Year Established should be derived'
        );

        /* ============================================================
           4. Assert – Address
           ============================================================ */

        System.assertEquals('SE', account.BillingCountry);
        System.assertEquals('SKELLEFTEÅ', account.BillingCity);
        System.assertEquals('Västerbotten', account.BillingState);
        System.assertEquals('93132', account.BillingPostalCode);
        System.assertEquals('Skellefteå', account.Billing_Municipality__c);
        System.assertNotEquals(
            null,
            account.BillingStreet,
            'Billing street should be constructed'
        );

        /* ============================================================
           5. Assert – Contact details
           ============================================================ */

        System.assertEquals('0910-12345', account.Phone);
        System.assertEquals('skelleftea@kaiding.se', account.Email__c);
        System.assertEquals('https://www.kaiding.se', account.Website);

        /* ============================================================
           6. Assert – Industry
           ============================================================ */

        System.assertEquals(
            'Advokatbyråverksamhet',
            account.Primary_Business_Category__c
        );
        System.assertEquals(
            '69101',
            account.Primary_Business_Category_Code__c
        );

        System.assertEquals(
            'Legal activities',
            account.Other_Business_Category__c
        );
        System.assertEquals(
            '6910',
            account.Other_Business_Category_Code__c
        );

        /* ============================================================
           7. Assert – Legal form
           ============================================================ */

        System.assertEquals('Kommanditbolag', account.Legalform__c);
        System.assertEquals('KB', account.Legalform_Code__c);

        /* ============================================================
           8. Assert – Employees
           ============================================================ */

        System.assertEquals(0, account.NumberOfEmployees);
        System.assertEquals(0, account.Min_Nr_Of_Employees_Org__c);
        System.assertEquals(0, account.Max_Nr_Of_Employees_Org__c);
    }
}
