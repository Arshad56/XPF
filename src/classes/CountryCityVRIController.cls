public class CountryCityVRIController {
	
     //method to check current login user has read only permission 
    @AuraEnabled
    public static Boolean showErroMsg(Id recordId){
        return ContactsAttendeesAura.showErroMsg(recordId);
    }
    @AuraEnabled
    public static String saveCountryCity(String recordId, string country , string city){
    	System.debug('SAVE COUNTRY CITY--->'+recordId);
    	System.debug('SAVE COUNTRY CITY--->'+country);
    	System.debug('SAVE COUNTRY CITY--->'+city);
    	
    	try{
    		Visit_Report_Item__c vri = new Visit_Report_Item__c();
    		vri.Id = recordId;
    		vri.Key_Country_Discussed__c = Utility.removeColon((country != null)?country:'');
    		vri.Key_City_Port_Discussed__c = Utility.removeColon((city != null)?city:'');
    		
    		update vri;
    		return 'SUCCESS';
            
        }
        catch(DMLexception e){
        	System.debug('EXCEPTION--->'+e);
            return 'Error :'+e.getMessage();
        }
    }
    
    @AuraEnabled
    public static List<String> getCountryCity(Id recordId){
        Visit_Report_Item__c vri = [SELECT Id, Key_City_Port_Discussed__c, Key_Country_Discussed__c FROM Visit_Report_Item__c 
        							   WHERE Id =:recordId LIMIT 1];
        List<String> strList = new List<String>();  
        strList.add((vri.Key_Country_Discussed__c != null)?vri.Key_Country_Discussed__c:'');
        strList.add((vri.Key_City_Port_Discussed__c != null)?vri.Key_City_Port_Discussed__c:'' );
        
        return strList;
    }
    @AuraEnabled
    public static List<String> getCountry(Id recordId){
        Visit_Report_Item__c vri = [SELECT Id, Key_City_Port_Discussed__c, Key_Country_Discussed__c FROM Visit_Report_Item__c 
        							   WHERE Id =:recordId LIMIT 1];
        List<String> strList = vri.Key_Country_Discussed__c.split(';');
        return strList;
    }
    @AuraEnabled
    public static List<String> getCity(Id recordId){
        Visit_Report_Item__c vri = [SELECT Id, Key_City_Port_Discussed__c, Key_Country_Discussed__c FROM Visit_Report_Item__c 
        							   WHERE Id =:recordId LIMIT 1];
        List<String> strList = vri.Key_City_Port_Discussed__c.split(';');
        return strList;
    }
}