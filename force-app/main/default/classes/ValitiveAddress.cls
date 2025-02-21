public class ValitiveAddress {

    public static ValitiveAddress.Address parseAddress(Map<String, Object> address){
        String type = (String) address?.get('_type');
        switch on type {
            when 'SE_NORMALIZED' {
                return new ValitiveAddress.SwedishAddress(address);
            }
            when 'RAW' {
                return new ValitiveAddress.RawAddress(address);
            }
            when else {
                return null;
            }
        }
    }

    public abstract class Address {

        public Type getClassType(){
    
            if (this instanceof ValitiveAddress.SwedishAddress) {
                return ValitiveAddress.SwedishAddress.class;
            }
            if (this instanceof ValitiveAddress.RawAddress) {
                return ValitiveAddress.RawAddress.class;
            }
            return null;
        }
    }
    
    
    public class RawAddress extends Address {
        public String type;
        public String country;
        public List<String> addressLines;
        public String kind;
    
        public RawAddress(Map<String, Object> address){
            this.type = (String) address.get('_type');
            this.country = (String) address.get('country');
            this.addressLines = (List<String>) System.JSON.deserialize(System.JSON.serialize(address.get('addressLines')), List<String>.class);
            this.kind = (String) address.get('kind');
        }
    }
    
    public class SwedishAddress extends Address{
        public String type;
        public String country;
        public String city;
        public String zip;
        public Geolocation geolocation;
        public String postbox;
        public String street;
        public String street2;
        public String streetNumber;
        public string numberSuffix;
        public String flat;
        public String careOf;
        public String county;
        public String municipality;
        public String misc;
        public String floor;
        public String entrance;
        public String kind;
    
        public SwedishAddress(Map<String, Object> address){
            this.type = (String) address.get('_type');
            this.country = (String) address.get('country');
            this.city = (String) address.get('city');
            this.zip = (String) address.get('zip');
            this.geolocation = new Geolocation((Map<String, Object>) address.get('geoPoint'));
            this.postbox = (String) address.get('postbox');
            this.street = (String) address.get('street');
            this.street2 = (String) address.get('street2');
            this.streetNumber = (String) address.get('number');
            this.numberSuffix = (String) address.get('numberSuffix');
            this.flat = (String) address.get('flat');
            this.careOf = (String) address.get('careOf');
            this.county = (String) address.get('county');
            this.municipality = (String) address.get('municipality');
            this.misc = (String) address.get('misc');
            this.floor = (String) address.get('floor');
            this.entrance = (String) address.get('entrance');
            this.kind = (String) address.get('kind');
        }
    }
    
    public class Geolocation {
        public Decimal latitude;
        public Decimal longitude;
    
        public Geolocation(Map<String, Object> geolocation){
            this.latitude = (Decimal) geolocation?.get('lat');
            this.longitude = (Decimal) geolocation?.get('long');
        }
    }   
}

