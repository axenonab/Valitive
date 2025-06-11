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
        String street = address.street + ' ' + address.streetNumber;
        if(!String.isBlank(address.numberSuffix)){
            street += address.numberSuffix;
        }
        if (!String.isBlank(address.flat)){
            street += ' lgh ' + address.flat;
        }
        return street;
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