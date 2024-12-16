public class ValitiveClientMock {

    private IValitivePropertiesProvider provider;
    public MultiRequestMock mockServer = new MultiRequestMock(new Map<String, HttpCalloutMock>());
    

    public ValitiveClientMock(IValitivePropertiesProvider provider) {
        this.provider = provider;
        buildMockServer();
    }

    

    public void buildMockServer(){
        
        SingleRequestMock authMock = new SingleRequestMock(
            200, 
            'OK',
            System.JSON.serialize(new Map<String, Object>{
                'access_token' => 'mock-access-token',
                'token_type' => 'bearer',
                'expires_in' => 3600,
                'scope' => 'mock-scope'
            }),
            null
        );

        SingleRequestMock addPersonToMonitorSerMock = new SingleRequestMock(
            200,
            'OK',
            System.JSON.serialize(new Map<String, Object>{
                '_type' => 'mock-type',
                'id' => 'mock-id',
                'monitoringSetId' => 'mock-monitoring-set-id',
                'updatedAt' => 'mock-datetime'
                }
            ),
            null
        );

        SingleRequestMock deletePersonFromMonitorSetMock = new SingleRequestMock(
            204,
            'OK',
            System.JSON.serialize(new Map<String, Object>{}),
            null    
        );

        SingleRequestMock getEventMock = new SingleRequestMock(
            200,
            'OK',
            System.JSON.serialize(new List<Object>{
                new Map<String, Object>{
                    'id' => 'mock-idSE_PERSON_NAME_CHANGED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'SE_PERSON_NAME_CHANGED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'givenName' => 'Sven',
                        'firstName' => 'Sven Lars',
                        'lastName' => 'Svenson',
                        'oldGivenName' => 'Johan',
                        'oldFirstName' => 'Johan Mark',
                        'oldLastName' => 'Johanson',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPERSON_LEGAL_ID_CHANGED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PERSON_LEGAL_ID_CHANGED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idSE_PERSON_ADDR_CHANGED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'SE_PERSON_ADDR_CHANGED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'address' => new Map<String, Object>{
                            '_type' => 'SE_NORMALIZED',
                            'country' => 'mock-country',
                            'city' => 'mock-city',
                            'zipCode' => 'mock-zip-code',
                            'geoPoint' => new Map<String, Object>{
                                'lat' => 0.0,
                                'long' => 0.0
                            },
                            'postBox' => 'mock-post-box',
                            'street' => 'mock-street',
                            'street2' => 'mock-street',
                            'streetNumber' => 'mock-street-number',
                            'numberSuffix' => 'mock-number-suffix',
                            'flat' => 'mock-flat',
                            'careOf' => 'mock-care-of',
                            'county' => 'mock-county',
                            'municiplaity' => 'mock-municipality',
                            'misc' => 'mock-misc',
                            'floor' => 'mock-floor',
                            'entrance' => 'mock-entrance',
                            'kind' => 'OFFICIAL'

                        }
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idSE_PERSON_ADDR_CHANGEDRAW',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'SE_PERSON_ADDR_CHANGED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'address' => new Map<String, Object>{
                            '_type' => 'RAW',
                            'country' => 'mock-country',
                            'addressLines' => new List<String>{'mock-address-line-1', 'mock-address-line-2'}
                        }
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idSE_PERSON_ADDR_CORRECTED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'SE_PERSON_ADDR_CORRECTED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'address' => new Map<String, Object>{
                            '_type' => 'SE_NORMALIZED',
                            'country' => 'mock-country',
                            'city' => 'mock-city',
                            'zipCode' => 'mock-zip-code',
                            'geoPoint' => new Map<String, Object>{
                                'lat' => 0.0,
                                'long' => 0.0
                            },
                            'postBox' => 'mock-post-box',
                            'street' => 'mock-street',
                            'street2' => 'mock-street',
                            'streetNumber' => 'mock-street-number',
                            'numberSuffix' => 'mock-number-suffix',
                            'flat' => 'mock-flat',
                            'careOf' => 'mock-care-of',
                            'county' => 'mock-county',
                            'municiplaity' => 'mock-municipality',
                            'misc' => 'mock-misc',
                            'floor' => 'mock-floor',
                            'entrance' => 'mock-entrance',
                            'kind' => 'OFFICIAL'

                        }
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idSE_PERSON_ADDR_CORRECTEDRAW',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'SE_PERSON_ADDR_CORRECTED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'address' => new Map<String, Object>{
                            '_type' => 'RAW',
                            'country' => 'mock-country',
                            'addressLines' => new List<String>{'mock-address-line-1', 'mock-address-line-2'}
                        }
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPHONE_BOUND',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PHONE_BOUND',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'number' => 'mock-number',
                        'partyId' => 'mock-party-id',
                        'kind' => 'MOBILE',
                        'registeredSince' => '"2021-08-23T14:55:05.327Z"',
                        'areaCode' => 'mock-area-code',
                        'countryCode' => 'mock-country-code'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPHONE_UNBOUND',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PHONE_UNBOUND',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'number' => 'mock-number',
                        'partyId' => 'mock-party-id',
                        'kind' => 'MOBILE',
                        'registeredSince' => '"2021-08-23T14:55:05.327Z"',
                        'areaCode' => 'mock-area-code',
                        'countryCode' => 'mock-country-code'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPERSON_PROTECTION_ACTIVATED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PERSON_PROTECTION_ACTIVATED',
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'since' => '"2021-08-23"',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPERSON_PROTECTION_DEACTIVATED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PERSON_PROTECTION_DEACTIVATED',
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846',
                        'since' => '"2021-08-23"',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"'
                    }
                },
                new Map<String, Object>{
                    'id' => 'mock-idPERSON_LEGAL_ID_CHANGED',
                    'detectedAt' => '"2021-08-23T14:55:05.327Z"',
                    'monitoringSetId' => 'mock-monitoring-set-id',
                    'subjectIds' => new List<String>{'198505229846'},
                    'payload' => new Map<String, Object>{
                        '_type' => 'PERSON_LEGAL_ID_CHANGED',
                        'id' => 'mock-id',
                        'timestamp' => '"2021-08-23T14:55:05.327Z"',
                        'validSince' => '"2021-08-23T14:55:05.327Z"',
                        'oldLegalId' => '198712229884',
                        'changeCode' => 23,
                        'personId' => 'mock-person-id',
                        'personLegalId' => '198403239846'
                    }
                }

            }),
            new Map<String, String>{ 
                'Next-Link' => this.provider.getBaseURL() + '/pub/api/' + this.provider.getApiVersion() + '/monitoring-set/b9b5a4601d204ba6ba7c3914b549ff0f/events?iterator=ewogICJkaXJlY3Rpb24iIDogIkZPUldBUkQiLAogICJzb3J0VmFsdWVzIiA6IFsgMTczNDMzMjEyNDg1MSwgImI5YjVhNDYwMWQyMDRiYTZiYTdjMzkxNGI1NDlmZjBmPC0-MjBjODkwZGU0LTkzMzgtNGYwMS04ZGMxLTRhYzE5OTFhZWIzYWFjYmRlZDM4LTAxMTUtNDUzYi05NDZiLTExMzY0NGU1M2E5MTEiIF0sCiAgInN0YXJ0SW5kZXgiIDogMTAwLAogICJzZWFyY2hDcml0ZXJpYUNoZWNrc3VtIiA6ICI1NjMwOGJkZDhiM2U2MTlmZWQyMzE0NTY3NDhkZDY5NyIKfQ',
                'Curr-Link' => 'mock-curr-link',
                'Prev-Link' => 'mock-prev-link',
                'Total-Count' => '10',
                'Result-Count' => '10',
                'Result-Range' => '1-10'
            }
        );

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>{
            this.provider.getBaseURL() + this.provider.getTokenEndpoint() => authMock,
            this.provider.getBaseURL() + '/pub/api/' + this.provider.getApiVersion() + '/monitoring-set/' + this.provider.getPrivateMonitoringSetId() + '/scope/se/person/1' => addPersonToMonitorSerMock,
            this.provider.getBaseURL() + '/pub/api/' + this.provider.getApiVersion() + '/monitoring-set/' + this.provider.getPrivateMonitoringSetId() + '/scope/' => deletePersonFromMonitorSetMock,
            this.provider.getBaseURL() + '/pub/api/' + this.provider.getApiVersion() + '/monitoring-set/' + this.provider.getPrivateMonitoringSetId() + '/events' => getEventMock
        };

        mockServer.addRequestMock(endpoint2TestResp);

    }



    public void setRequestMock(String url, HttpCalloutMock mock) {
        this.mockServer.addRequestMock(url, mock);
    }
}