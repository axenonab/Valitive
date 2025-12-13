public class ValitiveQuerySubjectsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private String importStatus;
    private Set<String> accountIds;

    @TestVisible
    private final ValitiveService valitiveService = new ValitiveService();
    private ValitiveUtils valitiveUtils = new ValitiveUtils();
    private static final String baseFilter = 'IsInMonitoringSet__c = true';

    private static final List<String> fieldsToSelect = new List<String>{
        'Id',
        'Valitive_Import_Process_Status__c',
        'Name',
        'Company_Number__c',
        'BillingCountry',
        'BillingState',
        'BillingPostalCode',
        'BillingCity',
        'BillingStreet',
        'Billing_Municipality__c',
        'Website',
        'Phone',
        'Email__c',
        'Status__c',
        'Year_Established__c',
        'Established__c',
        'Description',
        'Primary_Business_Category__c',
        'Primary_Business_Category_Code__c',
        'Other_Business_Category__c',
        'Other_Business_Category_Code__c',
        'Legalform__c',
        'Legalform_Code__c',
        'Stock_Exchange_Listed__c',
        'Share_Capital__c',
        'Latest_Period__c',
        'Period_Duration_In_Months__c',
        'Latest_Equity_Ratio__c',
        'Latest_Liquidity_Ratio__c',
        'Latest_Return_On_Equity__c',
        'Latest_Return_On_Assets__c',
        'Latest_Dept_Ratio__c',
        'Latest_Profit_Margin__c',
        'Latest_Total_Turnover__c',
        'Latest_Gross_Margin__c',
        'Latest_Year_Result__c',
        'Turnover_Group__c',
        'Min_Nr_Of_Employees_HQ__c',
        'Max_Nr_Of_Employees_HQ__c',
        'Min_Nr_Of_Employees_Org__c',
        'Max_Nr_Of_Employees_Org__c',
        'NumberOfEmployees'

    };
    
    public ValitiveQuerySubjectsBatch(String importStatus) {
        this.importStatus = importStatus;
            
    }

    public ValitiveQuerySubjectsBatch() {
        
    }

    public static ValitiveQuerySubjectsBatch withAccountIds(Set<String> accountIds) {
        ValitiveQuerySubjectsBatch batch = new ValitiveQuerySubjectsBatch();
        batch.accountIds = accountIds;
        return batch;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = buildQuery();
        System.debug('Query: ' + query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> accounts) {
        List<Account> accountsToUpdate = new List<Account>();
        Map<String, Account> formatedOrgNumberToAccount = new Map<String, Account>();

        for (Account account : accounts) {
            formatedOrgNumberToAccount.put(valitiveUtils.removeHyphen(account.Company_Number__c), account);
        }

        Map<String, String> queryParams = new Map<String, String> {
            ValitiveQueryParams.MONITORING_SET_IDS => this.valitiveService.getOrganisationMonitoringSetId(),
            ValitiveQueryParams.LEGAL_IDS => String.join(formatedOrgNumberToAccount.keySet(), ','),
            ValitiveQueryParams.ROW_LIMIT => '1000'
        };

        HttpResponse response = this.valitiveService.queryMonitoringSetScope(queryParams);
        if(response.getStatusCode() != 200) {
            return;
        }
        

        List<ValitiveMonitoringSetSubjectResponse> parsedResponse = ValitiveMonitoringSetSubjectResponse.parseList(response.getBody());
        for(ValitiveMonitoringSetSubjectResponse monitoringSetSubjectResponse : parsedResponse) {
            if(monitoringSetSubjectResponse.id.startsWith('19')){
                //remove the leading '19' from the id to match the Company_Number__c format
                monitoringSetSubjectResponse.id = monitoringSetSubjectResponse.id.substring(2);
            }
            System.debug('Processing monitoring set subject response: ' + monitoringSetSubjectResponse.id);
            Account account = formatedOrgNumberToAccount.get(monitoringSetSubjectResponse.id);
            if(account == null) {
                continue;
            }
            account.Valitive_Import_Process_Status__c = 'Completed';
            accountsToUpdate.add(handleOrgResponse(monitoringSetSubjectResponse, account));
        }

        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC) {
    }

    public String buildQuery() {
        String fields = String.join(fieldsToSelect, ',');
        if(importStatus != null) {
            return 'SELECT ' + fields + ' FROM Account WHERE ' + baseFilter + ' AND Valitive_Import_Process_Status__c = :importStatus';
        } 
        else if(accountIds != null) {
            return 'SELECT ' + fields + ' FROM Account WHERE ' + baseFilter + ' AND Id IN :accountIds';
        }
        else {
            return 'SELECT ' + fields + ' FROM Account WHERE ' + baseFilter;
        }

    }

    public Account handleOrgResponse(ValitiveMonitoringSetSubjectResponse response, Account account){
        ValitiveMonitoringSetSubjectResponse.SEOrg organisation = (ValitiveMonitoringSetSubjectResponse.SEOrg) response.data;

        if(organisation.orgName != null) {
            account.Name = valitiveUtils.isSameValue(account.Name, organisation.orgName.name) ? account.Name : organisation.orgName.name;
        }
        
        if(!organisation.addresses.isEmpty()) {
            for(ValitiveAddress.Address address: organisation.addresses) {
                if(address.getClassType() != ValitiveAddress.SwedishAddress.class) {
                    continue;
                }

                ValitiveAddress.SwedishAddress swedishAddress = (ValitiveAddress.SwedishAddress) address;
                if(swedishAddress.type != 'SE_ORG_NORMALIZED') {
                    continue;
                }
                if(swedishAddress.kind == 'MAIL') {
                    account.BillingCountry = valitiveUtils.isSameValue(account?.BillingCountry, swedishAddress.country) ? account?.BillingCountry : swedishAddress.country;
                    account.BillingCity = valitiveUtils.isSameValue(account?.BillingCity, swedishAddress.city) ? account?.BillingCity : swedishAddress.city.toUpperCase();
                    account.BillingState = valitiveUtils.isSameValue(account?.BillingState, swedishAddress.county) ? account?.BillingState : swedishAddress.county;
                    account.BillingPostalCode = valitiveUtils.isSameValue(account?.BillingPostalCode, swedishAddress.zip) ? account?.BillingPostalCode : valitiveUtils.formatZipCode(swedishAddress.zip);
                    account.Billing_Municipality__c = valitiveUtils.isSameValue(account?.Billing_Municipality__c, swedishAddress.municipality) ? account?.Billing_Municipality__c : swedishAddress.municipality;
                    if(swedishAddress.postbox != null) {
                        account.BillingStreet = valitiveUtils.isSameValue(account?.BillingStreet, swedishAddress.postbox) ? account?.BillingStreet : swedishAddress.postbox;
                    } else {
                        account.BillingStreet = valitiveUtils.isSameValue(account?.BillingStreet, valitiveUtils.constructAdressSteetString(swedishAddress)) ? account?.BillingStreet : valitiveUtils.constructAdressSteetString(swedishAddress);
                    }
                }

            }
        }

        if(!organisation.phones.isEmpty()){
            account.Phone = valitiveUtils.isSameValue(account?.Phone, organisation.phones[0].telNumber) ? account?.Phone : organisation.phones[0].telNumber;
        }
        if(!organisation.emails.isEmpty()){
            account.Email__c = valitiveUtils.isSameValue(account?.Email__c, organisation.emails[0]) ? account?.Email__c : organisation.emails[0];
        }
        if(!organisation.urls.isEmpty()){
            account.Website = valitiveUtils.isSameValue(account?.Website, organisation.urls[0]) ? account?.Website : organisation.urls[0];
        }

        account.Description = valitiveUtils.isSameValue(account?.Description, organisation.businessActivity) ? account?.Description : organisation.businessActivity;

        account.Primary_Business_Category__c = valitiveUtils.isSameValue(account?.Primary_Business_Category__c, organisation.primaryBusinessCategory.description) ? account?.Primary_Business_Category__c : organisation.primaryBusinessCategory.description;
        account.Primary_Business_Category_Code__c = valitiveUtils.isSameValue(account?.Primary_Business_Category_Code__c, organisation.primaryBusinessCategory.code) ? account?.Primary_Business_Category_Code__c : organisation.primaryBusinessCategory.code;

        if(!organisation.otherBusinessCategories.isEmpty()){
            account.Other_Business_Category__c = valitiveUtils.isSameValue(account?.Other_Business_Category__c, organisation.otherBusinessCategories[0].description) ? account?.Other_Business_Category__c : organisation.otherBusinessCategories[0].description;
            account.Other_Business_Category_Code__c = valitiveUtils.isSameValue(account?.Other_Business_Category_Code__c, organisation.otherBusinessCategories[0].code) ? account?.Other_Business_Category_Code__c : organisation.otherBusinessCategories[0].code;
        }

        account.Status__c = valitiveUtils.isSameValue(account?.Status__c, organisation.lifeCycle.status) ? account?.Status__c : organisation.lifeCycle.status;
        account.Year_Established__c = valitiveUtils.isSameValue(account?.Year_Established__c, organisation.lifeCycle.establishedOnYear) ? account?.Year_Established__c : organisation.lifeCycle.establishedOnYear;
        account.Established__c = valitiveUtils.isSameValue(account?.Established__c, organisation.lifeCycle.establishedOn) ? account?.Established__c : organisation.lifeCycle.establishedOn;

        account.Legalform__c = valitiveUtils.isSameValue(account?.Legalform__c, organisation.legalForm.name) ? account?.Legalform__c : organisation.legalForm.name;
        account.Legalform_Code__c = valitiveUtils.isSameValue(account?.Legalform_Code__c, organisation.legalForm.code) ? account?.Legalform_Code__c : organisation.legalForm.code;

        account.Stock_Exchange_Listed__c = valitiveUtils.isSameValue(account?.Stock_Exchange_Listed__c, organisation.financials.stockExchangeListed) ? account?.Stock_Exchange_Listed__c : organisation.financials.stockExchangeListed;
        account.Share_Capital__c = valitiveUtils.isSameValue(account?.Share_Capital__c, organisation.financials.shareCapital) ? account?.Share_Capital__c : organisation.financials.shareCapital;
        account.Turnover_Group__c = valitiveUtils.isSameValue(account?.Turnover_Group__c, organisation.financials.turnoverGroup) ? account?.Turnover_Group__c : organisation.financials.turnoverGroup;

        account.Min_Nr_Of_Employees_HQ__c = valitiveUtils.isSameValue(account?.Min_Nr_Of_Employees_HQ__c, organisation.manPowerInfo.minNrOfEmployeesHQ) ? account?.Min_Nr_Of_Employees_HQ__c : organisation.manPowerInfo.minNrOfEmployeesHQ;
        account.Max_Nr_Of_Employees_HQ__c = valitiveUtils.isSameValue(account?.Max_Nr_Of_Employees_HQ__c, organisation.manPowerInfo.maxNrOfEmployeesHQ) ? account?.Max_Nr_Of_Employees_HQ__c : organisation.manPowerInfo.maxNrOfEmployeesHQ;
        account.Min_Nr_Of_Employees_Org__c = valitiveUtils.isSameValue(account?.Min_Nr_Of_Employees_Org__c, organisation.manPowerInfo.minNrOfEmployeesOrg) ? account?.Min_Nr_Of_Employees_Org__c : organisation.manPowerInfo.minNrOfEmployeesOrg;
        account.Max_Nr_Of_Employees_Org__c = valitiveUtils.isSameValue(account?.Max_Nr_Of_Employees_Org__c, organisation.manPowerInfo.maxNrOfEmployeesOrg) ? account?.Max_Nr_Of_Employees_Org__c : organisation.manPowerInfo.maxNrOfEmployeesOrg;
        account.NumberOfEmployees = valitiveUtils.isSameValue(account?.NumberOfEmployees, organisation.manPowerInfo.nrOfEmployeesOrg) ? account?.NumberOfEmployees : organisation.manPowerInfo.nrOfEmployeesOrg;

        ValitiveMonitoringSetSubjectResponse.FinancialStatement financialStatement = getLatestFinancialStatement(organisation.financials);

        account.Latest_Period__c = valitiveUtils.isSameValue(account?.Latest_Period__c, financialStatement.period) ? account?.Latest_Period__c : financialStatement.period;
        account.Period_Duration_In_Months__c = valitiveUtils.isSameValue(account?.Period_Duration_In_Months__c, financialStatement.durationMonths) ? account?.Period_Duration_In_Months__c : financialStatement.durationMonths;
        account.Latest_Equity_Ratio__c = valitiveUtils.isSameValue(account?.Latest_Equity_Ratio__c, financialStatement.equityRatio) ? account?.Latest_Equity_Ratio__c : financialStatement.equityRatio;
        account.Latest_Liquidity_Ratio__c = valitiveUtils.isSameValue(account?.Latest_Liquidity_Ratio__c, financialStatement.liquidityRatio) ? account?.Latest_Liquidity_Ratio__c : financialStatement.liquidityRatio;
        account.Latest_Return_On_Equity__c = valitiveUtils.isSameValue(account?.Latest_Return_On_Equity__c, financialStatement.returnOnEquity) ? account?.Latest_Return_On_Equity__c : financialStatement.returnOnEquity;
        account.Latest_Return_On_Assets__c = valitiveUtils.isSameValue(account?.Latest_Return_On_Assets__c, financialStatement.returnOnAssets) ? account?.Latest_Return_On_Assets__c : financialStatement.returnOnAssets;
        account.Latest_Dept_Ratio__c = valitiveUtils.isSameValue(account?.Latest_Dept_Ratio__c, financialStatement.debtRatio) ? account?.Latest_Dept_Ratio__c : financialStatement.debtRatio;
        account.Latest_Profit_Margin__c = valitiveUtils.isSameValue(account?.Latest_Profit_Margin__c, financialStatement.profitMargin) ? account?.Latest_Profit_Margin__c : financialStatement.profitMargin;
        account.Latest_Total_Turnover__c = valitiveUtils.isSameValue(account?.Latest_Total_Turnover__c, financialStatement.totalTurnover) ? account?.Latest_Total_Turnover__c : financialStatement.totalTurnover;
        account.Latest_Gross_Margin__c = valitiveUtils.isSameValue(account?.Latest_Gross_Margin__c, financialStatement.grossMargin) ? account?.Latest_Gross_Margin__c : financialStatement.grossMargin;
        account.Latest_Year_Result__c = valitiveUtils.isSameValue(account?.Latest_Year_Result__c, financialStatement.yearResult) ? account?.Latest_Year_Result__c : financialStatement.yearResult;



        return account;
    }

    private ValitiveMonitoringSetSubjectResponse.FinancialStatement getLatestFinancialStatement(ValitiveMonitoringSetSubjectResponse.Financials financials) {
        if(financials == null || financials.financialStatements == null || financials.financialStatements.isEmpty()) {
            return new ValitiveMonitoringSetSubjectResponse.FinancialStatement();
        }
        ValitiveMonitoringSetSubjectResponse.FinancialStatement latestFinancialStatement = financials.financialStatements[0];
        for(ValitiveMonitoringSetSubjectResponse.FinancialStatement financialStatement : financials.financialStatements) {
            if(financialStatement.period > latestFinancialStatement.period) {
                latestFinancialStatement = financialStatement;
            }
        }
        return latestFinancialStatement;
    }


}