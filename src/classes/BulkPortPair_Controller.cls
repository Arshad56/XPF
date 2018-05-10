public class BulkPortPair_Controller {
    //method to check current login user has read only permission 
    @AuraEnabled
    public static Boolean showErroMsg(Id dealId){
        List<UserRecordAccess> userRecordAccesList = [SELECT RecordId, HasEditAccess,HasReadAccess,HasDeleteAccess FROM UserRecordAccess 
                                                      WHERE UserId = :userInfo.getUserId() AND RecordId = :dealId];
        
        UserRecordAccess userAccess = userRecordAccesList.get(0);
        if(userAccess.HasEditAccess)
            return false;
        else
            return true;

    }
    @AuraEnabled
    public static String getServiceRotations(String dealId){
    	List<RPWrapper> rpWrapTemp = new List<RPWrapper>();
    	//RPWrapper
    	//Service_Rotation__c rpRec{get;set;}
    	//<Service_Rotation_Detail__c> listRD{get;set;}
    	System.debug('dealId getServiceRotations-->'+dealId);
    	List<Service_Rotation__c> allSR = [Select Weight__c, Volume_Teus__c, Service__c, Req_Rate__c, Remarks__c, Id, Currency_Code__c, Arrangement__c, (Select Service_Rotation__c, Port__c, Terminal__c, Remarks__c From Rotation_Detail__r) From Service_Rotation__c where Deal__c =: dealId];
    	Set<String> serviceIds = new Set<String>();
    	for(Service_Rotation__c sr:allSR){
        	if (sr.Service__c != null ){
        		String[] srvcS = sr.Service__c.split(';'); 
        		for(String srvc: srvcS){
        			serviceIds.add(srvc);
        		}
        	}
        	if(!String.isBlank(sr.Remarks__c))
        	sr.Remarks__c = sr.Remarks__c.replaceAll('<[/a-zAZ0-9]*>','');
        	
        	for(Service_Rotation_Detail__c srd:sr.Rotation_Detail__r){
        		if(!String.isBlank(srd.Remarks__c))
        			srd.Remarks__c = srd.Remarks__c.replaceAll('<[/a-zAZ0-9]*>','');
        	}
		}
		Map<String,String> nameAndId = new Map<String,String>();
		List<Service__c> listServices = [select Id,Name from Service__c where Name =: serviceIds];
		for(Service__c srvc:listServices){
			nameAndId.put(srvc.Name, srvc.Id);
		}
		for(Service_Rotation__c sr:allSR){
			if (sr.Service__c != null){
	        		sr.Service__c = BulkPortPair_Controller.getServices(sr.Service__c,nameAndId);
			}else{ 
				sr.Service__c = '';
			}
	     	RPWrapper tempWrap = new RPWrapper();
	     	tempWrap.rpRec = sr;
	     	tempWrap.listRD = sr.Rotation_Detail__r;
	     		//if(sr.Rotation_Detail__r.size() == 0)
	     			//tempWrap.listRD.add(new Service_Rotation_Detail__c());
	     	rpWrapTemp.add(tempWrap);
		}
	        		
		/*for(Port_Pair__c pp:allPP)
			if (pp.Service__c != null)
	        		pp.Service__c = BulkPortPair_Controller.getServices(pp.Service__c,nameAndId);*/
	        		System.debug('dealId rpWrapTemp-->'+rpWrapTemp);
    	return JSON.serialize(rpWrapTemp);
    }
    @AuraEnabled
    public static String getPortPairs(String dealId){
    	List<Port_Pair__c> allPP = [select Id, Arragement__c,Currency_Code__c,Port_of_Discharge__c,Port_of_Loading__c,RV__c,Service__c,Terminal_of_Discharge__c,Terminal_of_Loading__c,Total_Value__c,Via_T_S__c,Volume_Teus__c,Weight__c,Req_Rate__c,Remarks__c from Port_Pair__c where Deal_Name__c =:dealId];
    	Set<String> serviceIds = new Set<String>();
    	for(Port_Pair__c pp:allPP){
        	if (pp.Service__c != null ){
        		String[] srvcS = pp.Service__c.split(';'); 
        		for(String srvc: srvcS){
        			serviceIds.add(srvc);
        		}
        	}else{
        		pp.Service__c = '';
        	}
        	if(!String.isBlank(pp.Remarks__c))
        	pp.Remarks__c = pp.Remarks__c.replaceAll('<[/a-zAZ0-9]*>','');
		}
		Map<String,String> nameAndId = new Map<String,String>();
		List<Service__c> listServices = [select Id,Name from Service__c where Name =: serviceIds];
		for(Service__c srvc:listServices){
			nameAndId.put(srvc.Name, srvc.Id);
		}
		for(Port_Pair__c pp:allPP)
			if (pp.Service__c != null)
	        		pp.Service__c = BulkPortPair_Controller.getServices(pp.Service__c,nameAndId);
    	return JSON.serialize(allPP);
    }
    @AuraEnabled
    public static List<Port_Pair__c> checkboxChecked(String jsonParams){
    	List<Port_Pair__c> listPortPairs =new List<Port_Pair__c>();
    	try {
        	listPortPairs = (List<Port_Pair__c>)JSON.deserialize(jsonParams, List<Port_Pair__c>.class);
        	for(Port_Pair__c pp:listPortPairs){
        		if(pp.Rv__c){
        			pp.Port_of_Loading__c = null;
	        		pp.Terminal_of_Loading__c = null;
	        		pp.Port_of_Discharge__c = null;
	        		pp.Terminal_of_Discharge__c = null;
        		}
        	}
	    } catch (Exception e) {
	        System.debug('Exception Occured --->'+e);
	    }
	    System.debug('listPortPairs listPortPairs --->'+listPortPairs);
    	return listPortPairs;
    }
	@AuraEnabled
    public static List<Port_Pair__c> addPortPair(String jsonParams, String rowsCount, String dealId){
    	
    	List<Port_Pair__c> listPortPairs;
    	try {
        	listPortPairs = (List<Port_Pair__c>)JSON.deserialize(jsonParams, List<Port_Pair__c>.class);
	    } catch (Exception e) {
	        System.debug('Exception Occured --->'+e);
	    }
	    
    	System.debug('111rowsCount-->'+rowsCount);
    	System.debug('1111listPortPairs-->'+listPortPairs);
    	for(Integer i = 1;i < = Integer.valueof(rowsCount); i++)
    		listPortPairs.add(new Port_Pair__c(Deal_Name__c = dealId));
    		
    	System.debug('rowsCount-->'+rowsCount);
    	System.debug('listPortPairs-->'+listPortPairs);
        return listPortPairs;
    }
    @AuraEnabled
    public static String savePortPairs(String dealId,String portPairJSON,String rotationPairJSON){
	   Savepoint sp = Database.setSavepoint();

		try {
	    	List<Port_Pair__c> listPortPairs = new List<Port_Pair__c>();
	    	List<RPWrapper> listRPWrappers = new List<RPWrapper>();
	    	List<Port_Pair__c> insertPP= new List<Port_Pair__c>();
	    	
	    	
	    	Map<String,String> nameAndId = new Map<String,String>();
	    	Map<Integer,Service_Rotation__c> RPMap = new Map<Integer,Service_Rotation__c>();
	    	Map<Integer,List<Service_Rotation_Detail__c>> RDMap = new Map<Integer,List<Service_Rotation_Detail__c>>();
	    	
	    	Set<Id> portIds = new Set<Id>();
	    	Set<String> serviceIds = new Set<String>();
	    	BulkPortPair_Controller bpc = new BulkPortPair_Controller();
	    	System.debug('portPairJSON-->'+portPairJSON);
	    	System.debug('rotationPairJSON-->'+rotationPairJSON);
	    	
	    		// parse JSON for Port Pairs and RP Wrapeer
	    		listPortPairs = (List<Port_Pair__c>)JSON.deserialize(portPairJSON, List<Port_Pair__c>.class);
	        	listRPWrappers = (List<RPWrapper>)JSON.deserialize(rotationPairJSON, List<RPWrapper>.class);
	        	
	        	Map<Id,Port_Pair__c> ppWithIdDelete = new Map<Id,Port_Pair__c>([select Id from Port_Pair__c where Deal_Name__c =:dealId]);
	        	
	    		for(Port_Pair__c pp:listPortPairs){
	    			if(pp.Id!= null){
	    				if(ppWithIdDelete.containsKey(pp.Id)){
	    					ppWithIdDelete.remove(pp.Id);
	    				}
	    			}
	    			System.debug('pp.Service__c --->'+pp.Service__c);
	    			// Get all Services Ids to fetch Name- In Multi lookup we get list of Ids
		        	if (pp.Service__c != null ){
		        		String[] srvcS = pp.Service__c.split(';'); 
		        		for(String srvc: srvcS){
		        			serviceIds.add(srvc);
		        		}
		        	}
	    		}
	    		
	    		Map<Id , Service_Rotation__c> srDelete =new Map<Id , Service_Rotation__c>([Select Weight__c, Volume_Teus__c, Service__c, Req_Rate__c, Remarks__c, Id, Currency_Code__c, Arrangement__c From Service_Rotation__c where Deal__c =: dealId]);
	    		Map<Id , Service_Rotation_Detail__c> srdDelete = new Map<Id,Service_Rotation_Detail__c > ([Select Service_Rotation__c, Port__c, Terminal__c, Remarks__c From Service_Rotation_Detail__c where Service_Rotation__c =: srDelete.keyset()]);
	    		for(RPWrapper rwp:listRPWrappers){
	    			if(rwp.rpRec.Id!= null){
	    				if(srDelete.containsKey(rwp.rpRec.Id)){
	    					if(srDelete.containsKey(rwp.rpRec.Id)){
	    						srDelete.remove(rwp.rpRec.Id);
	    					}
	    				}
	    				for(Service_Rotation_Detail__c rd: rwp.listRD){
		        			if(rd.Id != null ){
		        				
		        				if(srdDelete.containsKey(rd.Id)){
		        					srdDelete.remove(rd.Id);
		        				}
		        			}
		        		}
	    			}
		        	if (rwp.rpRec.Service__c != null || rwp.rpRec.Volume_Teus__c != null){ 
		        		if(rwp.rpRec.Service__c != null){
		        			String[] srvcS = rwp.rpRec.Service__c.split(';'); 
			        		// Get all Services Ids to fetch Name- In Multi lookup we get list of Ids
			        		System.debug('rwp--->'+rwp);
			        		for(String srvc: srvcS){
			        			serviceIds.add(srvc);
			        		}
		        		}
		        		// Get all Port Ids to fetch Name- To Populate on Parent Service Rotation field
			        	System.debug('rdList--->'+rwp.listRD);
		        		for(Service_Rotation_Detail__c rd: rwp.listRD){
		        			System.debug('rd.Port__c --->'+rd.Port__c );
		        			if(rd.Port__c != null){
		        				portIds.add(rd.Port__c);
		        			}
		        		}
		        	}
	    		}
	    		System.debug('serviceIds --->'+serviceIds);
	    		List<Service__c> listServices = [select Id,Name from Service__c where id =: serviceIds];
	    		Map<Id,Port__c> portIdWithName = new Map<Id,Port__c>([select Id,Name from Port__c where id =: portIds]);
	    		
	    		// put service name in Map of Id and Name. so that service Id can be replaced with Name
	    		for(Service__c srvc:listServices){
	    			nameAndId.put(srvc.Id, srvc.Name);
	    		}
	        	
	        	System.debug('listPortPairs --->'+listPortPairs);
	        	System.debug('listRPWrappers --->'+listRPWrappers);
	        	
	        	// Process Port pair
	        	for(Port_Pair__c pp:listPortPairs){
		        	if (pp.Volume_Teus__c != null){
		        		//Populate Services Name seperated by ';'
		        		pp.Service__c = BulkPortPair_Controller.getServices(pp.Service__c,nameAndId);
		        		//bpc.getServices(pp.Service__c,nameAndId);
		        		
		        		//pp.Arragement__c = portPairArrangement;
		        		pp.Deal_Name__c = dealId;
		        		
	        			insertPP.add(pp);
	        			
		        		System.debug('pp --->'+pp);
		        	}
	        	}
	        	System.debug('<------------------------------>');
	        	
	        	// Process Rotation Pair 
	        	Integer commonKey = 1;
	        	
	        	List<Service_Rotation_Detail__c> insertRD = new List<Service_Rotation_Detail__c>();
	        	for(RPWrapper rwp:listRPWrappers){
		        	if (rwp.rpRec.Volume_Teus__c != null){ 
		        		
		        		//Populate Services Name seperated by ';'
		        		if(rwp.rpRec.Service__c != null)
		        			rwp.rpRec.Service__c = BulkPortPair_Controller.getServices(rwp.rpRec.Service__c,nameAndId);
		        		
		        		//rwp.rpRec.arrangement__c = portPairArrangement;
		        		rwp.rpRec.Deal__c = dealId;
		        		rwp.rpRec.Port_Rotations__c = '';
		        		insertRD = new List<Service_Rotation_Detail__c>();
		        		
		        		System.debug('rwp --->'+rwp);
		        		Integer i = 1;
		        		
		        		// Process Rotation Detail 
		        		Integer k = 1;
		        		
		        		for(Service_Rotation_Detail__c rd: rwp.listRD){
		        			if(rd.Port__c != null){
		        				// To Populate Port Names Port1 - Port 2 - Port 3 - Port 3 - Port 5
		        				rwp.rpRec.Port_Rotations__c += ((k==1)?'':' - ')+portIdWithName.get(rd.Port__c).Name; 
		        				k++;
		        				//Creates Service Roration Detail Child Object
	        					rd.Service_Rotation__c = rwp.rpRec.Id;
	        					rd.Number__c = i;
	        					insertRD.add(rd);
	        					System.debug('rd --->'+rd);
	        					i++;
		        			}
		        		}
		        		
		        		if(insertRD.size()>0)
		        			RDMap.put(commonKey, insertRD);
		        		RPMap.put(commonKey, rwp.rpRec);
		        		System.debug('<------------------------------>');
		        		commonKey++;
		        	}
	        	}
	        	delete srdDelete.values();
	        	delete srDelete.values();
	        	delete ppWithIdDelete.values();
	        	
	        	System.debug(insertPP.size()+' insertPP --->'+insertPP);
	        	upsert insertPP;
	        	
	        	System.debug(' RPMap --->'+RPMap);
	        	System.debug(' RPMap.values() --->'+RPMap.values());
	        	upsert RPMap.values();
	        	
	        	insertRD = new List<Service_Rotation_Detail__c>();
	        	for(Integer intKey:RPMap.Keyset()){
	        		if(RDMap.containsKey(intKey)){
	        			for(Service_Rotation_Detail__c rd:RDMap.get(intKey)){
	        				rd.Service_Rotation__c = RPMap.get(intKey).Id;
	        				insertRD.add(rd);
	        			}
	        		}
	        	}
	        	System.debug(insertRD.size()+' insertRD --->'+insertRD);
	        	upsert insertRD;
	        	
	        return 'Success';
	    } catch (Exception e) {
    		   Database.rollback(sp);
    		
			return 'Error: '+e.getMessage();
		}
       
    }
    //returns Services Name seperated by ';'
    public Static String getServices(String servicesString, Map<String,String> nameAndId){
    	String[] srvcS = servicesString.split(';'); 
		servicesString = '';
		for(String srvc: srvcS){
			if(nameAndId.containsKey(srvc)){
				servicesString += nameAndId.get(srvc)+';';
			}
		}
    	return servicesString;
    }
    public class RPWrapper{
    	@AuraEnabled public Service_Rotation__c rpRec{get;set;}
    	@AuraEnabled public List<Service_Rotation_Detail__c> listRD{get;set;}
    	public RPWrapper(){
	    	rpRec = new Service_Rotation__c();
	    	rpRec.Service__c = '';
	    	listRD = new List<Service_Rotation_Detail__c>();
	    }
    }
}