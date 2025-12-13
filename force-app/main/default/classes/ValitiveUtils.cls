public class ValitiveUtils {
    public String removeHyphen(String ssn) {
        return ssn.replaceAll('-', '');
    }
    public String formatZipCode(String zipCode) {
        if (zipCode.length() == 5) {
            return zipCode.substring(0, 3) + ' ' + zipCode.substring(3, 5);
        }
        return zipCode;
    }
    public String constructAdressSteetString(ValitiveAddress.SwedishAddress address) {
        // This generate null null.
        String street = '';
        if(!String.isBlank(address.street)){
            street += address.street;
        }
        if(!String.isBlank(address.streetNumber)){
            street += ' ' + address.streetNumber;
        }
        if(!String.isBlank(address.numberSuffix)){
            street +=  ' ' + address.numberSuffix;
        }
        if (!String.isBlank(address.flat)){
            street += ' lgh ' + address.flat;
        }
        return street;
    }
    public String constructAdressPostBoxString(ValitiveAddress.SwedishAddress address) {
        String postBox = 'Box ' + address.postbox;
        return postBox;
    }
    public String constructAdressSteetString(Valitive_Event__c event) {
        String street = event.Street__c + ' ' + event.Property_Identifier__c;
        if(!String.isBlank(event.Number_Suffix__c)){
            street += event.Number_Suffix__c;
        }
        if (!String.isBlank(event.Flat__c)){
            street += ' lgh ' + event.Flat__c;
        }
        return street;
    }
    public String constructAdressPostBoxString(Valitive_Event__c event) {
        String postBox = 'Box ' + event.Postbox__c;
        return postBox;
    }
    public String formatPhoneNumber(ValitiveMonitoringSetSubjectResponse.PersonalPhone phone) {
        String telNumber = phone.telNumber;
        string regexReplace = '^46';
        String formatedNumber = telNumber.replaceAll(regexReplace, '0');
        return formatedNumber;
    }
    public Boolean isSameValue(String value1, String value2) {
        return value1?.toLowerCase() == value2?.toLowerCase();
    }
    public Boolean isSameValue(Boolean value1, Boolean value2) {
        return value1 == value2;
    }
    public Boolean isSameValue(Date value1, Date value2) {
        return value1 == value2;
    }
    public Boolean isSameValue(Decimal value1, Decimal value2) {
        return value1 == value2;
    }
}