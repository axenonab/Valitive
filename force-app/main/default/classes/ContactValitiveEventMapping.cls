public class ContactValitiveEventMapping {
    
    public static Contact mapPhoneBoundEventToContact(Contact con, Valitive_Event__c event) {
        if(event.Phone_Kind__c == 'MOBILE') {
            
            con.MobilePhone = formatPhoneNumber(event);
        } else {
            con.Phone = formatPhoneNumber(event);
        }
        return con;

    }

    public static Contact mapPhoneUnboundEventToContact(Contact con, Valitive_Event__c event) {
        //REDUNDANT
        return null;
    }

    public static Contact mapPersonProtectionActivatedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.Protected_Identity__c = true;
        return con;

    }

    public static Contact mapPersonProtectionDeactivatedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.Protected_Identity__c = false;
        return con;
    }

    public static Contact mapPersonLegalIdChangedEventToContact(Contact con, Valitive_Event__c event) {
        //THESE SHOULD ONLY BE FLAGGED AND NOT MAPPED TO CONTACT
        return null;
    }

    public static Contact mapPersonGenderChangedEventToContact(Contact con, Valitive_Event__c event) {
        //THESE SHOULD ONLY BE FLAGGED AND NOT MAPPED TO CONTACT
        return null;
    }

    public static Contact mapPersonAddrChangedEventToContact(Contact con, Valitive_Event__c event) {
        if(event.Address_Kind__c == 'FOREIGN') {
            con.Foreign_Address__c = true;
            return con;
        }
        con.MailingStreet = constructAdressSteetString(event);
        con.MailingCity = event.City__c != null ? event.City__c.toUpperCase() : null;
        con.MailingState = event.County__c;
        con.MailingPostalCode = formatZipCode(event.Zip__c);
        // con.MailingCountry = event.Country__c;
        con.MailingMunicipality__c = event.Municipality__c;
        return con;
    }

    public static Contact PersonAddrCorrectedEventToContact(Contact con, Valitive_Event__c event) {
        if(event.Address_Kind__c == 'FOREIGN') {
            con.Foreign_Address__c = true;
            return con;
        }
        con.MailingStreet = constructAdressSteetString(event);
        con.MailingCity = event.City__c.toUpperCase();
        con.MailingState = event.County__c;
        con.MailingPostalCode = formatZipCode(event.Zip__c);
        // con.MailingCountry = event.Country__c;
        con.MailingMunicipality__c = event.Municipality__c;
        return con;
    }

    public static Contact mapPersonNameChangedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.FirstName = event.Given_Name__c == null ? event.FirstName__c: event.Given_Name__c;
        con.LastName = event.LastName__c;
        return con;
    }

    public static Contact mapPersonDeceasedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.npsp__Deceased__c = true;
        con.Deceased_Date__c = event.Deceased_On__c;
        return con;
    }

    public static Contact mapGuardAddedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.Has_Trustee__c = true;
        con.Has_Trustee_Since__c = event.Guarded_Since__c;
        return con;
    }

    public static Contact mapGuardRemovedEventToContact(Contact con, Valitive_Event__c event) {
        
        con.Has_Trustee__c = false;
        con.Has_Trustee_Since__c = null;
        return con;
    }

    private static String constructAdressSteetString(Valitive_Event__c event) {
        String street = event.Street__c + ' ' + event.Property_Identifier__c;
        if(!String.isBlank(event.Number_Suffix__c)){
            street += event.Number_Suffix__c;
        }
        if (!String.isBlank(event.Flat__c)){
            street += ' lgh ' + event.Flat__c;
        }
        return street;
    }

    private static String formatPhoneNumber(Valitive_Event__c event) {
        String telNumber = event.Telephone_Number__c;
        String countryCode = event.Country_Code__c.replaceAll('[^0-9 ]', '');
        string regexReplace = String.format('^{0}', new List<Object>{countryCode});
        String formatedNumber = telNumber.replaceAll(regexReplace, '0');
        return formatedNumber;

    }

    private static String formatZipCode(String zipCode) {
        if (zipCode.length() == 5) {
            return zipCode.substring(0, 3) + ' ' + zipCode.substring(3, 5);
        }
        return zipCode;
    }


}