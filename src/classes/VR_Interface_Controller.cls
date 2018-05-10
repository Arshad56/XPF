/*
 created: 02/03/2018 18:19
 Author: Arshad Shaikh 
 Description: 
 in VR_Interface Lightning Component 
*/
public class VR_Interface_Controller {
    public static Map<String,Id> recordtypemap {get;set;}
    
	
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
    		vri.Key_Country_Discussed__c = country;
    		vri.Key_City_Port_Discussed__c = city;
    		
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
    
	// Returns list of VR Item list related to Visit Report
	@AuraEnabled
    public static String getAllVRI(String vrId){
    	System.debug('Controller getAllVRI--->'+vrId);
    	List<Visit_Report_Item__c> tempList = [select id, Name, Account_Name__r.Name, Key_Country_Discussed__c, Key_City_Port_Discussed__c from Visit_Report_Item__c where Visit_Report_ID__c =: vrId order by createdDate DESC];
    	String tempListString = JSON.serialize(tempList);
    	
    	return tempListString;
    }
    // Returns list of Deal list related to Visit Report
    @AuraEnabled 
    public static String getAllDeal(String vrId){
    	System.debug('Controller getAllDeal--->'+vrId); 
    	List<Opportunity> tempList = [select id, Name, Account.Name, type, Sub_Type__c,StageName,RecordType.Name from Opportunity where Visit_Report_ID__c =: vrId order by createdDate DESC];
    	String tempListString = JSON.serialize(tempList);
    	
    	return tempListString;
    }
     // Returns list of MI list related to Visit Report
     @AuraEnabled 
    public static String getAllMI(String vrId){
    	System.debug('Controller getAllMI--->'+vrId); 
    	List<Market_Intelligence__c> tempList = [select id, Name, Type__c,Account_Name__c,Account_Name__r.Name,Remarks__c from Market_Intelligence__c where Visit_Report__c =: vrId order by createdDate DESC];
    	String tempListString = JSON.serialize(tempList);
    	
    	return tempListString;
    }
     // Returns list of Exp Item list related to Visit Report
     @AuraEnabled 
    public static String getAllExp(String vrId){
    	System.debug('Controller getAllExp--->'+vrId); 
    	//VR_Interface_Controller.wait(4000);
    	List<Expense_Item__c> tempList = [Select Name, Id, Amount__c,Currency_Code__c, Date__c,Type__c, Visit_Report__c,Remarks__c From Expense_Item__c where Visit_Report__c =: vrId order by createdDate DESC];
    	String tempListString = JSON.serialize(tempList);
    	
    	return tempListString;
    }
     // Returns picklist values for mentioned object and field 
    @AuraEnabled        
	public static List<String> getPickListValuesIntoList(String objectType, String selectedField){
        system.debug('>>objectType>>'+objectType);
        List<String> pickListValuesList = new List<String>();
		if(selectedField == 'RecordType'){
	        for(RecordType rt : [SELECT Id,Name,IsActive FROM RecordType WHERE SobjectType=:objectType and IsActive = true]){
	            pickListValuesList.add(rt.Name);
	        }        
	        return pickListValuesList;
		}else{
		    Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
		    Schema.DescribeSObjectResult res = convertToObj.getDescribe();
		    Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
		    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		    for( Schema.PicklistEntry pickListVal : ple){
		        pickListValuesList.add(pickListVal.getLabel());
		    }     
		    return pickListValuesList;
		}
	}
    // initialise list of VR share wrapper
    @AuraEnabled
    public static List<ShareWrapper> initShareList(){
    	List<ShareWrapper> temp = new List<ShareWrapper>();
    	return temp;
    }
    // initialise list of MI share wrapper
    @AuraEnabled
    public static List<MIShareWrapper> initMIShareList(){
    	List<MIShareWrapper> temp = new List<MIShareWrapper>();
    	return temp;
    } 
    // initialise list of Exp share wrapper
    @AuraEnabled
    public static List<ExpShareWrapper> initExpShareList(){
    	List<ExpShareWrapper> temp = new List<ExpShareWrapper>();
    	return temp;
    }
    // returns all countries from custom setting 
     @AuraEnabled
     public static List<String> getKeyCountries(){
    	List<Multi_Country__c> mcs = Multi_Country__c.getall().values();
    	List<String> countries = new List<String>();
    	for(Multi_Country__c cntry: mcs){
    		countries.add(cntry.Name);
    	}
    	countries.sort();
    	return countries;
    }
    //returns all cities from custom setting 
    @AuraEnabled
     public static List<String> getKeyCities(String country){
    	Multi_Country__c multCntry = Multi_Country__c.getValues(country);
    	List<String> cities = new List<String>();
    	String CityTA = '';
    	for(Integer i = 1; i <= 7 ; i++){
    		if(!String.isBlank((String) multCntry.get('City_'+i+'__c'))){
				CityTA = (String) multCntry.get('City_'+i+'__c');
				CityTA = CityTA.replace('\r\n', ';');
				CityTA = CityTA.replace('\n', ';');
				CityTA = CityTA.replace('\r', ';');
				cities.addAll(CityTA.split(';'));
			}
    	}
		cities.sort();
    	return cities;
    }
    // Add share record in VR Share List
    @AuraEnabled
    public static List<ShareWrapper> initShareCard(String groupUserId, String parent, String vrShareListJSON){
    	Id idParam =  Id.valueOf(groupUserId);
    	System.debug('vrShareListJSON-->'+vrShareListJSON);
    	List<ShareWrapper> listSWs = new List<ShareWrapper>();
    	listSWs = (List<ShareWrapper>)JSON.deserialize(vrShareListJSON, List<ShareWrapper>.class);
    	
    	ShareWrapper tempWrap = new ShareWrapper();
    	Set<Id> ugId= new Set<Id>();
    	System.debug('listSWs-->'+listSWs);
    	for(ShareWrapper ll:listSWs){
    		ugId.add(ll.vps.UserOrGroupId);
    	}
    	System.debug('ugId-->'+ugId);
    	System.debug('idParam-->'+idParam);
    	if(!ugId.contains(idParam)){
    			System.debug('ugId.contains(idParam)-->'+ugId.contains(idParam));
    			Visit_Report_Item__Share tempVR = new Visit_Report_Item__Share(
									    	//ParentId = parent,
									    	UserOrGroupId = idParam,
									    	AccessLevel = 'Read'
									    	);
		    	tempWrap.vps = tempVR;
		    	tempWrap.AccessLevel = 'Read';
		    	if(idParam.getSObjectType().getDescribe().getName() == 'Group'){
		    		Group grp = [select Id,Name from Group where id =: groupUserId];
		    		tempWrap.name = grp.Name;
		    		tempWrap.grp = 'Group';
		    		System.debug('grp-->'+grp);
		    	}else{
		    		User usr = [select Id, Name from User where id =: groupUserId];
		    		tempWrap.name = usr.Name;
		    		tempWrap.grp = 'USER';
		    		System.debug('usr-->'+usr);
		    	}
		    	
		    	listSWs.add(tempWrap);
    	}
    	System.debug('listSWs-->'+listSWs);
    	return listSWs;
    }
    // Add share record in Deal Share List
    @AuraEnabled
    public static List<DealShareWrapper> initDealShareCard(String groupUserId, String parent, String dealShareListJSON){
    	Id idParam =  Id.valueOf(groupUserId);
    	System.debug('dealShareListJSON-->'+dealShareListJSON);
    	List<DealShareWrapper> listSWs = new List<DealShareWrapper>();
    	listSWs = (List<DealShareWrapper>)JSON.deserialize(dealShareListJSON, List<DealShareWrapper>.class);
    	
    	DealShareWrapper tempWrap = new DealShareWrapper();
    	Set<Id> ugId= new Set<Id>();
    	System.debug('listSWs-->'+listSWs);
    	for(DealShareWrapper ll:listSWs){
    		ugId.add(ll.dealShr.UserOrGroupId);
    	}
    	System.debug('ugId-->'+ugId);
    	System.debug('idParam-->'+idParam);
    	if(!ugId.contains(idParam)){
    			System.debug('ugId.contains(idParam)-->'+ugId.contains(idParam));
    			OpportunityShare tempVR = new OpportunityShare(
									    	//ParentId = parent,
									    	UserOrGroupId = idParam,
									    	OpportunityAccessLevel = 'Read'
									    	); 
		    	tempWrap.dealShr = tempVR;
		    	tempWrap.AccessLevel = 'Read';
		    	if(idParam.getSObjectType().getDescribe().getName() == 'Group'){
		    		Group grp = [select Id,Name from Group where id =: groupUserId];
		    		tempWrap.name = grp.Name;
		    		tempWrap.grp = 'Group';
		    		System.debug('grp-->'+grp);
		    	}else{
		    		User usr = [select Id, Name from User where id =: groupUserId];
		    		tempWrap.name = usr.Name;
		    		tempWrap.grp = 'USER';
		    		System.debug('usr-->'+usr);
		    	}
		    	
		    	listSWs.add(tempWrap);
    	}
    	System.debug('listSWs-->'+listSWs);
    	return listSWs;
    }
    // Add share record in MI Share List
    @AuraEnabled
    public static List<MIShareWrapper> initMIShareCard(String groupUserId, String parent, String miShareListJSON){
    	Id idParam =  Id.valueOf(groupUserId);
    	System.debug('miShareListJSON-->'+miShareListJSON);
    	List<MIShareWrapper> listSWs = new List<MIShareWrapper>();
    	listSWs = (List<MIShareWrapper>)JSON.deserialize(miShareListJSON, List<MIShareWrapper>.class);
    	
    	MIShareWrapper tempWrap = new MIShareWrapper();
    	Set<Id> ugId= new Set<Id>();
    	System.debug('listSWs-->'+listSWs);
    	for(MIShareWrapper ll:listSWs){
    		ugId.add(ll.mis.UserOrGroupId);
    	}
    	System.debug('ugId-->'+ugId);
    	System.debug('idParam-->'+idParam);
    	if(!ugId.contains(idParam)){
    			System.debug('ugId.contains(idParam)-->'+ugId.contains(idParam));
    			Market_Intelligence__Share tempMI = new Market_Intelligence__Share(
									    	//ParentId = parent,
									    	UserOrGroupId = idParam,
									    	AccessLevel = 'Read'
									    	);
		    	tempWrap.mis = tempMI;
		    	tempWrap.AccessLevel = 'Read';
		    	if(idParam.getSObjectType().getDescribe().getName() == 'Group'){
		    		Group grp = [select Id,Name from Group where id =: groupUserId];
		    		tempWrap.name = grp.Name;
		    		tempWrap.grp = 'Group';
		    		System.debug('grp-->'+grp);
		    	}else{
		    		User usr = [select Id, Name from User where id =: groupUserId];
		    		tempWrap.name = usr.Name;
		    		tempWrap.grp = 'USER';
		    		System.debug('usr-->'+usr);
		    	}
		    	
		    	listSWs.add(tempWrap);
    	}
    	System.debug('listSWs-->'+listSWs);
    	return listSWs;
    }
    // Add share record in EXP Share List
    @AuraEnabled
    public static List<ExpShareWrapper> initExpShareCard(String groupUserId, String parent, String expShareListJSON){
    	Id idParam =  Id.valueOf(groupUserId);
    	System.debug('expShareListJSON-->'+expShareListJSON);
    	List<ExpShareWrapper> listSWs = new List<ExpShareWrapper>();
    	listSWs = (List<ExpShareWrapper>)JSON.deserialize(expShareListJSON, List<ExpShareWrapper>.class);
    	
    	ExpShareWrapper tempWrap = new ExpShareWrapper();
    	Set<Id> ugId= new Set<Id>();
    	System.debug('listSWs-->'+listSWs);
    	for(ExpShareWrapper ll:listSWs){
    		ugId.add(ll.eis.UserOrGroupId);
    	}
    	System.debug('ugId-->'+ugId);
    	System.debug('idParam-->'+idParam);
    	if(!ugId.contains(idParam)){
    			System.debug('ugId.contains(idParam)-->'+ugId.contains(idParam));
    			Expense_Item__Share tempExp = new Expense_Item__Share(
									    	//ParentId = parent,
									    	UserOrGroupId = idParam,
									    	AccessLevel = 'Read'
									    	);
		    	tempWrap.eis = tempExp;
		    	tempWrap.AccessLevel = 'Read';
		    	if(idParam.getSObjectType().getDescribe().getName() == 'Group'){
		    		Group grp = [select Id,Name from Group where id =: groupUserId];
		    		tempWrap.name = grp.Name;
		    		tempWrap.grp = 'Group';
		    		System.debug('grp-->'+grp);
		    	}else{
		    		User usr = [select Id, Name from User where id =: groupUserId];
		    		tempWrap.name = usr.Name;
		    		tempWrap.grp = 'USER';
		    		System.debug('usr-->'+usr);
		    	}
		    	
		    	listSWs.add(tempWrap);
    	}
    	System.debug('listSWs-->'+listSWs);
    	return listSWs;
    }
    // Add Save VRI under Visit Report 
    @AuraEnabled
    public static String saveVRIWrap(String vriWrapperJSON){
    	List<Visit_Report_Item__Share> vrShrInsert = new List<Visit_Report_Item__Share>();
    	Set<Id> userIds = new Set<Id>();
    	Set<String> serviceIds = new Set<String>();
    	Map<String,String> idAndName = new Map<String,String>();
    	String userType = Schema.SObjectType.User.getKeyPrefix();
		String groupType = Schema.SObjectType.Group.getKeyPrefix();
		
    	vriWrapper vriWrp =  (vriWrapper)JSON.deserialize(vriWrapperJSON, vriWrapper.class);
    	
    	System.debug('vriWrp.vrItem-->'+vriWrp.vrItem);
    	System.debug('vriWrp.vriConList-->'+vriWrp.vriConList);
    	System.debug('vriWrp.listWrapShr-->'+vriWrp.listWrapShr);
    	System.debug('vriWrp.taskInstance-->'+vriWrp.taskInstance);
    	System.debug('vriWrp.taskUserList-->'+vriWrp.taskUserList);
    	
    	System.debug('=====================================');
    	
    	Visit_Report_Item__c insertVRI = new Visit_Report_Item__c();
    	insertVRI = vriWrp.vrItem;
    	if( insertVRI.Key_Country_Discussed__c == '--- None ---'){
    		insertVRI.Key_Country_Discussed__c = null;
    		insertVRI.Key_City_Port_Discussed__c = null;
    	}
    	if(!String.isBlank(insertVRI.Discussed_Service__c)){
    		String[] srvcS = insertVRI.Discussed_Service__c.split(';'); 
    		for(String srvc: srvcS){
    			serviceIds.add(srvc);
    		}
	        List<Service__c> listServices = [select Id,Name from Service__c where Id =: serviceIds];
			for(Service__c srvc:listServices){
				idAndName.put(srvc.Id, srvc.Name);
			}
			insertVRI.Discussed_Service__c = BulkPortPair_Controller.getServices(insertVRI.Discussed_Service__c,idAndName);
			srvcS = insertVRI.Discussed_Service__c.split(';'); 
	        srvcS.sort();
	        insertVRI.Discussed_Service__c = '';
			for(String srvc: srvcS){
				insertVRI.Discussed_Service__c += srvc+';';
			}
    	}	
		if(!String.isBlank(vriWrp.vriConList)){
			Set<String> setConIds = new Set<String>(vriWrp.vriConList.split(';'));
	    	System.debug('setConIds-->'+setConIds);
	    	List<Contact> conList = [select id , Name from Contact where id =: setConIds];
	    	System.debug('conList-->'+conList);
	    	Integer k = 1;
	    	insertVRI.Contact_s__c = '';
	    	for(Contact con: conList){
	    		insertVRI.Contact_s__c += ((k==1)?'':';')+con.Name;
	    		k++;
	    		System.debug('insertVRI.Contact_s__c-->'+insertVRI.Contact_s__c);
	    	}
	    	insertVRI.Contact_Ids__c = vriWrp.vriConList;
		}
		insertVRI.Key_Country_Discussed__c = Utility.removeColon(insertVRI.Key_Country_Discussed__c);
		insertVRI.Key_City_Port_Discussed__c = Utility.removeColon(insertVRI.Key_City_Port_Discussed__c);
		insertVRI.Discussed_Service__c = Utility.removeColon(insertVRI.Discussed_Service__c);
    	insert insertVRI;
    	System.debug('insertVRI-->'+insertVRI);
    	
    	for(ShareWrapper shr: vriWrp.listWrapShr){
    		if(shr.notify){
				System.debug('Send Email---');
				String idType = (shr.vps.UserOrGroupId);
				if(idType.startsWithIgnoreCase(userType)){
					userIds.add(shr.vps.UserOrGroupId);
				}else{
					userIds.addAll(Utility.getUserIds(shr.vps.UserOrGroupId));
				}
			}
    		shr.vps.ParentId = insertVRI.Id;
    		System.debug('shr-->'+shr);
    		vrShrInsert.add(shr.vps);
    	}
    	insert vrShrInsert;
    	
    	Utility.sendEmailShare(insertVRI.Id,'Visit_Report_Item__Share',userIds);
    	
    	System.debug('vrShrInsert-->'+vrShrInsert);
    	
    	if(!String.isBlank(vriWrp.taskUserList)){
    		List<Task> insertTask =new List<Task>();
			String[] userlist = vriWrp.taskUserList.split(';');
			for(String usr:userlist){
				Task tempTask = new Task();
				tempTask = vriWrp.taskInstance.clone(false, false, false, false);
				tempTask.whatId = insertVRI.Id;
				tempTask.OwnerId = usr;
				insertTask.add(tempTask);
			}
			insert insertTask;
			System.debug('insertTask-->'+insertTask);
    	}
    	
    	return '';
    }
    // Add Save Deal under Visit Report 
    @AuraEnabled
    public static String saveDealWrap(String dealWrapperJSON){
    	try{
    		Set<Id> userIds = new Set<Id>();
	    	String userType = Schema.SObjectType.User.getKeyPrefix();
			String groupType = Schema.SObjectType.Group.getKeyPrefix();
			
    		List<Visit_Report_Item__Share> vrShrInsert = new List<Visit_Report_Item__Share>();
			
    		DealWrapper dealWrp =  (DealWrapper)JSON.deserialize(dealWrapperJSON, DealWrapper.class);
	    	
	    	System.debug('dealWrp.dealItem-->'+dealWrp.dealItem);
	    	System.debug('dealWrp.rt-->'+dealWrp.rt);
	    	System.debug('dealWrp.StageName-->'+dealWrp.StageName);
	    	System.debug('dealWrp.listWrapShr-->'+dealWrp.listWrapShr);
	    	System.debug('dealWrp.taskInstance-->'+dealWrp.taskInstance);
	    	System.debug('dealWrp.taskUserList-->'+dealWrp.taskUserList);
	    	System.debug('=====================================');
			
			Opportunity insertDeal = new Opportunity();
			
	    	insertDeal = dealWrp.dealItem;
	    	if(!String.isBlank(dealWrp.rt))
	    		insertDeal.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(dealWrp.rt).getRecordTypeId();
	    	if(String.isBlank(insertDeal.StageName))
	    		insertDeal.StageName = 'New/Lead';	
			insertDeal.CloseDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
	    	insert insertDeal;
	    	System.debug('insertDeal-->'+insertDeal);
	    	
	    	List<OpportunityShare> dealShrInsert = new List<OpportunityShare>();
	    	for(DealShareWrapper shr: dealWrp.listWrapShr){
	    		if(shr.notify){
					System.debug('Send Email---');
					String idType = (shr.dealShr.UserOrGroupId);
					if(idType.startsWithIgnoreCase(userType)){
						userIds.add(shr.dealShr.UserOrGroupId);
					}else{
						userIds.addAll(Utility.getUserIds(shr.dealShr.UserOrGroupId));
					}
				}
	    		shr.dealShr.OpportunityId = insertDeal.Id;
	    		System.debug('shr-->'+shr);
	    		dealShrInsert.add(shr.dealShr);
	    	}
	    	insert dealShrInsert;
	    	
	    	Utility.sendEmailShare(insertDeal.Id,'OpportunityShare',userIds);
	    	
	    	System.debug('dealShrInsert-->'+dealShrInsert);
	    	
	    	if(!String.isBlank(dealWrp.taskUserList)){
	    		List<Task> insertTask =new List<Task>();
				String[] userList = dealWrp.taskUserList.split(';');
				for(String usr:userList){
					Task tempTask = new Task();
					tempTask = dealWrp.taskInstance.clone(false, false, false, false);
					tempTask.whatId = insertDeal.Id;
					tempTask.OwnerId = usr;
					insertTask.add(tempTask);
				}
				insert insertTask;
				System.debug('insertTask-->'+insertTask);
	    	}
    	}catch(Exception e){
    		return e+'';
    	}
    	
    	
    	return '';
    }
    // Add Save MI under Visit Report 
    @AuraEnabled
    public static String saveMIWrap(String miWrapperJSON){
    	try{
	    	String userType = Schema.SObjectType.User.getKeyPrefix();
			String groupType = Schema.SObjectType.Group.getKeyPrefix();
			
    		MIWrapper miWrp =  (MIWrapper)JSON.deserialize(miWrapperJSON, MIWrapper.class);
	    	
	    	System.debug('miWrp.miItem-->'+miWrp.miItem);
	    	System.debug('miWrp.miType-->'+miWrp.miType);
	    	System.debug('miWrp.listWrapShr-->'+miWrp.listWrapShr);
	    	System.debug('miWrp.taskInstance-->'+miWrp.taskInstance);
	    	System.debug('miWrp.taskUserList-->'+miWrp.taskUserList);
	    	System.debug('=====================================');
			
			Market_Intelligence__c insertMI = new Market_Intelligence__c();
			
	    	insertMI = miWrp.miItem;
	    	insertMI.City_Port__c = Utility.removeColon(insertMI.City_Port__c);
	    	insert insertMI;
	    	System.debug('insertMI-->'+insertMI);
	    	
	    	List<Market_Intelligence__Share> miShrInsert = new List<Market_Intelligence__Share>();
	    	Set<Id> userIds = new Set<Id>();
	    	for(MIShareWrapper shr: miWrp.listWrapShr){
	    		if(shr.notify){
					System.debug('Send Email---');
					String idType = (shr.mis.UserOrGroupId);
					if(idType.startsWithIgnoreCase(userType)){
						userIds.add(shr.mis.UserOrGroupId);
					}else{
						userIds.addAll(Utility.getUserIds(shr.mis.UserOrGroupId));
					}
				}
	    		shr.mis.ParentId = insertMI.Id;
	    		System.debug('shr-->'+shr);
	    		miShrInsert.add(shr.mis);
	    	}
	    	insert miShrInsert;
	    	System.debug('miShrInsert-->'+miShrInsert);
	    	Utility.sendEmailShare(insertMI.Id,'Market_Intelligence__Share',userIds);
	    	
	    	if(!String.isBlank(miWrp.taskUserList)){
	    		List<Task> insertTask =new List<Task>();
				String[] userIdList = miWrp.taskUserList.split(';');
				for(String usr:userIdList){
					Task tempTask = new Task();
					tempTask = miWrp.taskInstance.clone(false, false, false, false);
					tempTask.whatId = insertMI.Id;
					tempTask.OwnerId = usr;
					insertTask.add(tempTask);
				}
				insert insertTask;
				System.debug('insertTask-->'+insertTask);
	    	}
    	}catch(Exception e){
    		return e+'';
    	}
    	
    	
    	return '';
    }
    // Add Save Exp under Visit Report 
    @AuraEnabled
    public static Id saveExpWrap(String expWrapperJSON, String fileName, String base64Data, String contentType, String fileId){
    	try{
    		ExpWrapper expWrp =  (ExpWrapper)JSON.deserialize(expWrapperJSON, ExpWrapper.class);
	    	
	    	System.debug('expWrp.expItem-->'+expWrp.expItem);
	    	System.debug('expWrp.miType-->'+expWrp.expType);
	    	System.debug('expWrp.listWrapShr-->'+expWrp.listWrapShr);
	    	System.debug('expWrp.taskInstance-->'+expWrp.taskInstance);
	    	System.debug('expWrp.taskUserList-->'+expWrp.taskUserList);
	    	System.debug('=====================================');
			
			Expense_Item__c insertExp = new Expense_Item__c();
			
	    	insertExp = expWrp.expItem;
	    	insert insertExp;
	    	System.debug('insertExp-->'+insertExp);
	    	
	    	
	    	List<Expense_Item__Share> expShrInsert = new List<Expense_Item__Share>();
	    	for(ExpShareWrapper shr: expWrp.listWrapShr){
	    		shr.eis.ParentId = insertExp.Id;
	    		System.debug('shr-->'+shr);
	    		expShrInsert.add(shr.eis);
	    	}
	    	insert expShrInsert;
	    	System.debug('expShrInsert-->'+expShrInsert);
	    	
	    	if(!String.isBlank(expWrp.taskUserList)){
	    		List<Task> insertTask =new List<Task>();
				String[] userIds = expWrp.taskUserList.split(';');
				for(String usr:userIds){
					Task tempTask = new Task();
					tempTask = expWrp.taskInstance.clone(false, false, false, false);
					tempTask.whatId = insertExp.Id;
					tempTask.OwnerId = usr;
					insertTask.add(tempTask);
				}
				insert insertTask;
				System.debug('insertTask-->'+insertTask);
	    	}
	    	return insertExp.Id;
    	}catch(Exception e){
    		System.debug('Exception occured-->'+e);
    		return  null;
    	}
    	return null;
    }
    // Initialise VRI wrapper 
    @AuraEnabled
    public static VriWrapper initVRIWrap(String recordId){
    	Visit_Report__c vr = [select id,Agenda__c,Account_Name__c,Contact_Ids__c from Visit_Report__c where id=: recordId];
    	
    	VriWrapper temp = new VriWrapper();
    	temp.vrItem = new Visit_Report_Item__c();
    	temp.vrItem.Account_Name__c = vr.Account_Name__c;
    	//temp.vrItem.Account_Name__c = vr.Contact_Ids__c;
    	temp.vrItem.Agenda__c = vr.Agenda__c;
    	temp.vriConList = vr.Contact_Ids__c;
    	
    	temp.Visit_Country = '--None--';
    	temp.Visit_City_Port = '';
    	temp.listWrapShr = new List<ShareWrapper>();
    	temp.taskInstance = new Task();
    	
    	//Populate Share from Visit Plan
    	List<String> fieldsName = new String[] { 'Id', 'ParentId', 'UserOrGroupId','accessLevel' };
		String subQuery = '(select ' + String.join(fieldsName, ', ') + ' from Shares Order by UserOrGroupId Asc)'; 
		String mainQuery = 'select '+subQuery+ ' from Visit_Report__c where id =: recordId'; 
		
		Map<String, String> idWithNameMap = new Map<String, String>();
    	for(Group grp : [select Id,Name from Group])
    		idWithNameMap.put(grp.Id, grp.Name);
    	for(User usr : [select Id,Name from User])
    		idWithNameMap.put(usr.Id, usr.Name);
    	list<ShareWrapper> listShare = new List<ShareWrapper>();
    	for(Visit_Report__c obj : Database.Query(mainQuery)){
			for(Visit_Report__Share objShr: obj.Shares){
				if(userInfo.getuserId() != objShr.UserOrGroupId){
					System.debug('objShr-->'+objShr);
					ShareWrapper tempShare = new ShareWrapper();
					Visit_Report_Item__Share tempVR = new Visit_Report_Item__Share(
								    	UserOrGroupId = objShr.UserOrGroupId,
								    	AccessLevel = (objShr.AccessLevel =='All')?'Edit':objShr.AccessLevel
								    	);
					tempShare.vps = tempVR;
	    			tempShare.AccessLevel = tempVR.AccessLevel;
	    			tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
	    			if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
						tempShare.grp = 'Group';
					}else{
						tempShare.grp = 'User';
					}
					listShare.add(tempShare);
				}
			}
		}
		temp.listWrapShr = listShare;
    	return temp;
    }
    // Initialise Deal wrapper 
    @AuraEnabled
    public static DealWrapper initDealWrap(String recordId){
    	DealWrapper temp = new DealWrapper();
    	temp.dealItem = new Opportunity();
    	temp.dealItem.Name = '--System Generated--';
    	
    	//Populate Share from Deal
    	List<String> fieldsName = new String[] { 'Id', 'ParentId', 'UserOrGroupId','AccessLevel' };
		String subQuery = '(select ' + String.join(fieldsName, ', ') + ' from Shares Order by UserOrGroupId Asc)'; 
		String mainQuery = 'select '+subQuery+ ' from Visit_Report__c where id =: recordId'; 
		System.debug('mainQuery-->'+mainQuery);
		Map<String, String> idWithNameMap = new Map<String, String>();
    	for(Group grp : [select Id,Name from Group])
    		idWithNameMap.put(grp.Id, grp.Name);
    	for(User usr : [select Id,Name from User])
    		idWithNameMap.put(usr.Id, usr.Name);
    	list<DealShareWrapper> listShare = new List<DealShareWrapper>();
    	
    	for(Visit_Report__c obj : Database.Query(mainQuery)){
    		System.debug('obj-->'+obj);
			for(Visit_Report__Share objShr: obj.Shares){
				System.debug('objShr-->'+objShr);
				if(userInfo.getuserId() != objShr.UserOrGroupId){
					System.debug('objShr-->'+objShr);
					DealShareWrapper tempShare = new DealShareWrapper();
					OpportunityShare tempDeal = new OpportunityShare(
								    	UserOrGroupId = objShr.UserOrGroupId,
								    	OpportunityAccessLevel = (objShr.AccessLevel =='All')?'Edit':objShr.AccessLevel
								    	);
					tempShare.dealShr = tempDeal;
	    			tempShare.AccessLevel = tempDeal.OpportunityAccessLevel;
	    			tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
	    			if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
						tempShare.grp = 'Group';
					}else{
						tempShare.grp = 'User';
					}
					listShare.add(tempShare);
				}
			}
		}
		temp.listWrapShr = listShare;
		
    	temp.taskInstance = new Task();
    	return temp;
    }
    // Initialise MI wrapper 
    @AuraEnabled
    public static MIWrapper initMIWrap(){
    	MIWrapper temp = new MIWrapper();
    	temp.miItem = new Market_Intelligence__c();
    	temp.listWrapShr = new List<MIShareWrapper>();
    	temp.taskInstance = new Task();
    	return temp;
    }
    // Initialise EXP wrapper 
    @AuraEnabled
    public static ExpWrapper initExpWrap(){
    	ExpWrapper temp = new ExpWrapper();
    	temp.expItem = new Expense_Item__c(Date__c = System.Today());
    	temp.listWrapShr = new List<ExpShareWrapper>();
    	temp.taskInstance = new Task();
    	return temp;
    }
    //---------------------
    //  Deal wrapper Class
    public class DealWrapper{
    	@AuraEnabled public Opportunity dealItem{get;set;}
    	@AuraEnabled public List<DealShareWrapper> listWrapShr{get;set;}
    	@AuraEnabled public String taskUserList{get;set;}
    	@AuraEnabled public String rtID{get;set;}
    	@AuraEnabled public String rt{get;set;}
    	@AuraEnabled public String StageName{get;set;}
    	@AuraEnabled public Task taskInstance{get;set;}
    	public dealWrapper(){
	    	dealItem = new Opportunity();
	    	listWrapShr = new List<DealShareWrapper>();
	    	taskInstance = new Task();
	    	rtID = '';
	    	rt = '';
	    }
    }
    public class DealShareWrapper{
    	@AuraEnabled public OpportunityShare dealShr{get;set;}
    	@AuraEnabled public String name{get;set;}
    	@AuraEnabled public String grp{get;set;}
    	@AuraEnabled public String AccessLevel{get;set;}
    	@AuraEnabled public Boolean notify{get;set;}
    	public DealShareWrapper(){
	    	dealShr = new OpportunityShare();
	    	name = '';
	    	grp = '';
	    	AccessLevel = '';
	    	notify = false;
	    }
    }
    //---------------------
    //  Deal wrapper Class
    public class VriWrapper{
    	@AuraEnabled public Visit_Report_Item__c vrItem{get;set;}
    	@AuraEnabled public List<ShareWrapper> listWrapShr{get;set;}
    	@AuraEnabled public String taskUserList{get;set;}
    	@AuraEnabled public String vriConList{get;set;}
    	@AuraEnabled public String Visit_Country{get;set;}
    	@AuraEnabled public String Visit_City_Port{get;set;}
    	@AuraEnabled public Task taskInstance{get;set;}
    	public vriWrapper(){
	    	vrItem = new Visit_Report_Item__c();
	    	listWrapShr = new List<ShareWrapper>();
	    	taskInstance = new Task();
	    	Visit_Country = '';
	    	Visit_City_Port = '';
	    }
    }
    public class ShareWrapper{
    	@AuraEnabled public Visit_Report_Item__Share vps{get;set;}
    	@AuraEnabled public String name{get;set;}
    	@AuraEnabled public String grp{get;set;}
    	@AuraEnabled public String AccessLevel{get;set;}
    	@AuraEnabled public Boolean notify{get;set;}
    	public ShareWrapper(){
	    	vps = new Visit_Report_Item__Share();
	    	name = '';
	    	grp = '';
	    	AccessLevel = '';
	    	notify = false;
	    }
    }
    //---------------------
    //  MI wrapper Class
    public class MIWrapper{
    	@AuraEnabled public Market_Intelligence__c miItem{get;set;}
    	@AuraEnabled public String miType{get;set;}
    	@AuraEnabled public List<MIShareWrapper> listWrapShr{get;set;}
    	@AuraEnabled public String taskUserList{get;set;}
    	@AuraEnabled public Task taskInstance{get;set;}
    	public MIWrapper(){
	    	miItem = new Market_Intelligence__c();
	    	listWrapShr = new List<MIShareWrapper>();
	    	taskInstance = new Task();
	    	miType = '';
	    }
    }
	public class MIShareWrapper{
    	@AuraEnabled public Market_Intelligence__Share mis{get;set;}
    	@AuraEnabled public String name{get;set;}
    	@AuraEnabled public String grp{get;set;}
    	@AuraEnabled public String AccessLevel{get;set;}
    	@AuraEnabled public Boolean notify{get;set;}
    	public MIShareWrapper(){
	    	mis = new Market_Intelligence__Share();
	    	name = '';
	    	grp = '';
	    	AccessLevel = '';
	    	notify = false;
	    }
    }
    //---------------------
    //  EXP wrapper Class
    public class ExpWrapper{
    	@AuraEnabled public Expense_Item__c expItem{get;set;}
    	@AuraEnabled public String expType{get;set;}
    	@AuraEnabled public List<ExpShareWrapper> listWrapShr{get;set;}
    	@AuraEnabled public String taskUserList{get;set;}
    	@AuraEnabled public Task taskInstance{get;set;}
    	public ExpWrapper(){
	    	expItem = new Expense_Item__c();
	    	listWrapShr = new List<ExpShareWrapper>();
	    	taskInstance = new Task();
	    	expType = '';
	    }
    }
	public class ExpShareWrapper{
    	@AuraEnabled public Expense_Item__Share eis{get;set;}
    	@AuraEnabled public String name{get;set;}
    	@AuraEnabled public String grp{get;set;}
    	@AuraEnabled public String AccessLevel{get;set;}
    	public ExpShareWrapper(){
	    	eis = new Expense_Item__Share();
	    	name = '';
	    	grp = '';
	    	AccessLevel = '';
	    }
    }
    //---------------------
}