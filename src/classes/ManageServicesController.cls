public class ManageServicesController {
     //get the existing contacts 
    @AuraEnabled
    public static String getServices(Id visitReportId){
        Visit_Report_Item__c visitReport = [SELECT Id, Discussed_Service__c 
                                            FROM Visit_Report_Item__c
                                            WHERE Id =:visitReportId LIMIT 1];
      	Set<String> serviceIds = new Set<String>();
      	Map<String,String> nameAndId = new Map<String,String>();
        system.debug('>>>visitReport>>>'+visitReport);
    	if (visitReport.Discussed_Service__c != null ){
    		String[] srvcS = visitReport.Discussed_Service__c.split(';'); 
    		for(String srvc: srvcS){
    			serviceIds.add(srvc);
    		}
    	}
        List<Service__c> listServices = [select Id,Name from Service__c where Name =: serviceIds];
		for(Service__c srvc:listServices){
			nameAndId.put(srvc.Name, srvc.Id);
		}
        visitReport.Discussed_Service__c = BulkPortPair_Controller.getServices(visitReport.Discussed_Service__c,nameAndId);
        return visitReport.Discussed_Service__c;
        
    }
    
    //method to check current login user has read only permission ,then show error msg
    @AuraEnabled
    public static Boolean showErroMsg(Id recordId){
        List<UserRecordAccess> userRecordAccesList = [SELECT RecordId, HasEditAccess,HasReadAccess
                                                      FROM UserRecordAccess 
                                                      WHERE UserId = :userInfo.getUserId() AND RecordId = :recordId];
        
        UserRecordAccess userAccess = userRecordAccesList.get(0);
        if(userAccess.HasEditAccess)
            return false;
        else
            return true;
        
    }
    
    @AuraEnabled
    public static string updateServices(String visitId, string services) {
        try{
			System.debug('visitId--'+visitId);
			System.debug('services--'+services);
            Set<String> serviceIds = new Set<String>();
	      	Map<String,String> idAndName = new Map<String,String>();
	    	if (services != null ){
	    		String[] srvcS = services.split(';'); 
	    		for(String srvc: srvcS){
	    			serviceIds.add(srvc);
	    		}
	    	}
	        List<Service__c> listServices = [select Id,Name from Service__c where Id =: serviceIds];
			for(Service__c srvc:listServices){
				idAndName.put(srvc.Id, srvc.Name);
			}
			Visit_Report_Item__c visitReport = new Visit_Report_Item__c();
			visitReport.id = visitId;
	        visitReport.Discussed_Service__c = BulkPortPair_Controller.getServices(services,idAndName);
	        
	        String[] srvcS = visitReport.Discussed_Service__c.split(';'); 
	        srvcS.sort();
	        visitReport.Discussed_Service__c = '';
    		for(String srvc: srvcS){
    			visitReport.Discussed_Service__c += srvc+';';
    		}
    		visitReport.Discussed_Service__c = Utility.removeColon(visitReport.Discussed_Service__c);
    		
	        update visitReport;
            return 'SUCCESS';
            
        }
        catch(DMLexception e){
            return 'Error :'+e.getMessage();
        }
    }
}