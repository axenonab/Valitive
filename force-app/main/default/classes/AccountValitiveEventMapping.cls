public class AccountValitiveEventMapping {

    static ValitiveUtils valitiveUtils = new ValitiveUtils();

    public static Account mapOrgStatusChangedEventToAccount(Account acc, Valitive_Event__c event) {
 
        acc.Status__c = event.Org_Status__c;
        return acc;
    }

    public static Account mapOrgNameChangedEventToAccount(Account acc, Valitive_Event__c event) {
        
        acc.Name = event.Org_Name__c;
        return acc;
    }

    public static Account mapOrgAddrChangedEventToAccount(Account acc, Valitive_Event__c event) {
        if(event.Address_Kind__c == 'MAIL'){
            acc.BillingCity = event.City__c.toUpperCase();
            acc.BillingState = event.County__c;
            acc.BillingPostalCode = valitiveUtils.formatZipCode(event.Zip__c);
            acc.BillingCountry = event.Country_Code__c;
            if(event.Postbox__c != null){
                acc.BillingStreet = event.Postbox__c;
            } else {
                acc.BillingStreet = valitiveUtils.constructAdressSteetString(event);
            }
        }

        return acc;
    }

    public static Account mapOrgAddrCorrectedEventToAccount(Account acc, Valitive_Event__c event) {
        if(event.Address_Kind__c == 'MAIL'){
            acc.BillingCity = event.City__c.toUpperCase();
            acc.BillingState = event.County__c;
            acc.BillingPostalCode = valitiveUtils.formatZipCode(event.Zip__c);
            acc.BillingCountry = event.Country_Code__c;
            if(event.Postbox__c != null){
                acc.BillingStreet = event.Postbox__c;
            } else {
                acc.BillingStreet = valitiveUtils.constructAdressSteetString(event);
            }
        }

        return acc;
    }

    public static Account mapOrgKPIResultChangedEventToAccount(Account acc, Valitive_Event__c event) {
        
        acc.Latest_Period__c = event.Period__c;
        acc.Period_Duration_In_Months__c = event.Duration_In_Months__c != null ? Integer.valueOf(event.Duration_In_Months__c) : null;
        acc.Latest_Year_Result__c = event.New_KPI_Result_Value__c;
        return acc;
    }

    public static Account mapOrgArchivedEventToAccount(Account acc, Valitive_Event__c event) {
        
        acc.IsInMonitoringSet__c = false;
        acc.Exclude_From_Monitoring_Set__c = true;
        return acc;
    }
}