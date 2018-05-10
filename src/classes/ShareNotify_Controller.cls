public class ShareNotify_Controller {
	public static Map<String, String> idWithNameMap;
	public static ShareNotifyWrapper tempShare;
	public static List<ShareNotifyWrapper> listShare;
	public static String recordId;
	
	@AuraEnabled
	public static String saveRecords(String recordId, String shareListJSON, Boolean isUpdate, String removedIds){
		   Savepoint sp = Database.setSavepoint();
		
		try{
			String userType = Schema.SObjectType.User.getKeyPrefix();
			String groupType = Schema.SObjectType.Group.getKeyPrefix();
			
			List<String> deleteRecList = (removedIds != null)?(List<String>)JSON.deserialize(removedIds, List<String>.class):new List<String>();
			System.debug('removedIds-->'+removedIds +'  deleteRecList-->'+deleteRecList);
			System.debug('shareListJSON-->'+shareListJSON);
	    	List<ShareNotifyWrapper> listSWs = new List<ShareNotifyWrapper>();
	    	listSWs = (List<ShareNotifyWrapper>)JSON.deserialize(shareListJSON, List<ShareNotifyWrapper>.class);
	    	System.debug('listSW-->'+listSWs);
	    	
	    	Schema.SObjectType sobjectType = Id.valueOf(recordId).getSObjectType();
			String sobjectName = sobjectType.getDescribe().getName();
			String sobjectLabel = sobjectType.getDescribe().getLabel();
			String shareApi = '';
			if(sobjectName.contains('__c')){
				shareApi = sobjectName.replace('__c','__Share');
			}else{
				shareApi = sobjectName+ 'Share';
			}
			List<String> fieldsName = new String[] { 'Id', ((sobjectName.contains('__c'))?'Parent':sobjectName)+'Id', 'UserOrGroupId',((sobjectName.contains('__c'))?'':sobjectName)+'accessLevel' };
			List<sObject> listInsert;
			List<sObject> listDelete;
			set<Id> userIds = new set<Id>();
			set<Id> missingManualIds =new set<Id>();
			if(shareApi == 'Visit_Report__Share'){
				listInsert = new List<Visit_Report__Share>();
				listDelete = new List<Visit_Report__Share>();
				for(Visit_Report__Share vrs: [select Id from Visit_Report__Share where parentId =: recordId]){
					missingManualIds.add(vrs.Id);
				}
			}else if(shareApi == 'Visit_Report_Item__Share'){
				listInsert = new List<Visit_Report_Item__Share>();
				listDelete = new List<Visit_Report_Item__Share>();
				for(Visit_Report_Item__Share vri: [select Id from Visit_Report_Item__Share where parentId =: recordId]){
					missingManualIds.add(vri.Id);
				}
			}else if(shareApi == 'OpportunityShare'){
				listInsert = new List<OpportunityShare>();
				listDelete = new List<OpportunityShare>();
				for(OpportunityShare ops: [select Id from OpportunityShare where OpportunityId =: recordId]){
					missingManualIds.add(ops.Id);
				}
			}else if(shareApi == 'Market_Intelligence__Share'){
				listInsert = new List<Market_Intelligence__Share>();
				listDelete = new List<Market_Intelligence__Share>();
				for(Market_Intelligence__Share mis: [select Id from Market_Intelligence__Share where parentId =: recordId]){
					missingManualIds.add(mis.Id);
				}
			}
			set<Id> presentIds =new set<Id>();
			for(ShareNotifyWrapper sh:listSWs){
				System.debug('sh---'+sh); 
				if(sh.recId != '')
					presentIds.add(sh.recId);
				if(sh.recId == '' || sh.manual){
					sObject obj = Schema.getGlobalDescribe().get(shareApi).newSObject() ;
					if(sh.recId != ''){
						obj.put(fieldsName[0],sh.recId);
					}else{
						obj.put(fieldsName[1],recordId);           
						obj.put(fieldsName[2], sh.UserOrGroupId);
					}
					//obj.put(fieldsName[1],recordId);           
					//obj.put(fieldsName[2], sh.UserOrGroupId); 
					obj.put(fieldsName[3], sh.accessLevel);
					System.debug('sh.name---'+sh.name); 
					System.debug('sh.accessLevel---'+sh.accessLevel); 
					System.debug('');
					if(sh.notify){
						System.debug('Send Email---');
						String idType = (sh.UserOrGroupId);
						System.debug('1userIds-->'+userIds);
						if(idType.startsWithIgnoreCase(userType)){
							userIds.add(sh.UserOrGroupId);
						}else{
							userIds.addAll(Utility.getUserIds(sh.UserOrGroupId));
						}
						System.debug('2userIds-->'+userIds);
					}
					listInsert.add(obj);
				}
			}  
			System.debug('listInsert-->'+listInsert);
			upsert listInsert;
			System.debug('listInsert2-->'+listInsert);
			
			System.debug(shareApi+ ' '+isUpdate+' presentIds-->'+presentIds);
			//To Remove records from list
			if(isUpdate){
				System.debug('missingManualIds1-->'+missingManualIds);
				missingManualIds.removeAll(presentIds);
				System.debug('missingManualIds2-->'+missingManualIds);
				ShareNotify_Controller.deleteShareRecords(shareApi,deleteRecList,listDelete);
			}
			
			//To send email for checked
			Utility.sendEmailShare(recordId,shareApi,userIds);
	   
			return 'Success';
    	}catch(Exception e){
    		   Database.rollback(sp);
    		
			return 'Error: '+e.getMessage();
		}
	}
	public static void deleteShareRecords(String shareApi,List<String> missingManualIds, List<SObject> listDelete){
		String mainQuery = 'select id from '+shareApi+' where id =: missingManualIds'; 
		for(SObject sob : Database.Query(mainQuery)){
			listDelete.add(sob);
		}
			delete listDelete;
	}
	@AuraEnabled
	public static Boolean getIsOwner(String recordId){
    	Schema.SObjectType sobjectType = Id.valueOf(recordId).getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		String mainQuery = 'select ownerId from '+sobjectName+' where id =: recordId'; 
		
		User usr = [SELECT Profile.Name FROM User WHERE Id =:userInfo.getuserId()];
		if(usr.Profile.Name == 'System Administrator')
            return true;
		if(sobjectName == 'Visit_Report__c'){
			Visit_Report__c vr = Database.Query(mainQuery);
			if(vr.ownerId == userInfo.getUserId())
				return true;
		}else if(sobjectName == 'Visit_Report_Item__c'){
			Visit_Report_Item__c vr = Database.Query(mainQuery);
			if(vr.ownerId == userInfo.getUserId())
				return true;
		}else if(sobjectName == 'Opportunity'){
			Opportunity vr = Database.Query(mainQuery);
			if(vr.ownerId == userInfo.getUserId())
				return true;
		}else if(sobjectName == 'Market_Intelligence__c'){
			Market_Intelligence__c vr = Database.Query(mainQuery);
			if(vr.ownerId == userInfo.getUserId())
				return true;
		}
		return false;
	}
	@AuraEnabled
    public static List<ShareNotifyWrapper> initShareCard(String groupUserId, String parent, String shareListJSON){
        recordId = parent;
        System.debug('parent-->'+parent);
    	Schema.SObjectType sobjectType = Id.valueOf(recordId).getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		System.debug('sobjectName-->'+sobjectName);
		String sobjectLabel = sobjectType.getDescribe().getLabel();
		System.debug('describe.getLabel()-->'+sobjectLabel);
		String shareApi = '';
		if(sobjectName.contains('__c')){
			shareApi = sobjectName.replace('__c','__Share');
		}else{
			shareApi = sobjectName+ 'Share';
		}
		System.debug('shareApi-->'+shareApi);
		List<String> fieldsName = new String[] { 'Id', ((sobjectName.contains('__c'))?'Parent':sobjectName)+'Id', 'UserOrGroupId',((sobjectName.contains('__c'))?'':sobjectName)+'accessLevel' };
		String subQuery = '(select ' + String.join(fieldsName, ', ') + ' from Shares Order by UserOrGroupId Asc)'; 
		String mainQuery = 'select '+subQuery+ ' from '+sobjectName+' where id =: recordId'; 
		System.debug('mainQuery-->'+mainQuery);
		
		Set<Id> ugId= new Set<Id>();
		
		if(shareApi == 'Visit_Report__Share'){
			ugId = ShareNotify_Controller.getVRshareList(mainQuery,parent);
		}else if(shareApi == 'Visit_Report_Item__Share'){
			ugId = ShareNotify_Controller.getVRIshareList(mainQuery,parent);
		}else if(shareApi == 'OpportunityShare'){
			ugId = ShareNotify_Controller.getOpportunityshareList(mainQuery,parent);
		}else if(shareApi == 'Market_Intelligence__Share'){
			ugId = ShareNotify_Controller.getMIshareList(mainQuery,parent);
		}
		
    	Id idParam =  Id.valueOf(groupUserId);
    	System.debug('shareListJSON-->'+shareListJSON);
    	List<ShareNotifyWrapper> listSWs = new List<ShareNotifyWrapper>();
    	listSWs = (List<ShareNotifyWrapper>)JSON.deserialize(shareListJSON, List<ShareNotifyWrapper>.class);
    	
    	ShareNotifyWrapper tempWrap = new ShareNotifyWrapper();
    	
    	System.debug('listSWs-->'+listSWs);
    	for(ShareNotifyWrapper sn:listSWs){
    		ugId.add(sn.UserOrGroupId);
    	}
    	System.debug('ugId-->'+ugId);
    	System.debug('idParam-->'+idParam);
    	if(!ugId.contains(idParam)){
    			System.debug('ugId.contains(idParam)-->'+ugId.contains(idParam));
		    	tempWrap.UserOrGroupId = idParam;
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
    @AuraEnabled
    public static List<ShareNotifyWrapper> getShareList(String recordId){
    	Schema.SObjectType sobjectType = Id.valueOf(recordId).getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		System.debug('sobjectName-->'+sobjectName);
		String sobjectLabel = sobjectType.getDescribe().getLabel();
		System.debug('describe.getLabel()-->'+sobjectLabel);
		String shareApi = '';
		if(sobjectName.contains('__c')){
			shareApi = sobjectName.replace('__c','__Share');
		}else{
			shareApi = sobjectName+ 'Share';
		}
		System.debug('shareApi-->'+shareApi);
		
		List<String> fieldsName = new String[] { 'Id', ((sobjectName.contains('__c'))?'Parent':sobjectName)+'Id', 'UserOrGroupId',((sobjectName.contains('__c'))?'':sobjectName)+'accessLevel','RowCause' };
		
		String subQuery = '(select ' + String.join(fieldsName, ', ') + ' from Shares Order by UserOrGroupId Asc)'; 
		
		String mainQuery = 'select '+subQuery+ ' from '+sobjectName+' where id =: recordId'; 
		System.debug('mainQuery-->'+mainQuery);
		
		idWithNameMap = new Map<String, String>();
    	for(Group grp : [select Id,Name from Group]){
    		idWithNameMap.put(grp.Id, grp.Name);
    	}
    	for(User usr : [select Id,Name from User]){
    		idWithNameMap.put(usr.Id, usr.Name);
    	}
    	
		if(shareApi == 'Visit_Report__Share'){
			return ShareNotify_Controller.getVRshare(mainQuery,recordId);
		}else if(shareApi == 'Visit_Report_Item__Share'){
			return ShareNotify_Controller.getVRIshare(mainQuery,recordId);
		}else if(shareApi == 'OpportunityShare'){
			return ShareNotify_Controller.getOpportunityshare(mainQuery,recordId);
		}else if(shareApi == 'Market_Intelligence__Share'){
			return ShareNotify_Controller.getMIshare(mainQuery,recordId);
		}
		
        return new List<ShareNotifyWrapper>();
    }
    public static Set<Id> getVRshareList( String mainQuery,String recordId){
    	Set<Id> usrIds = new Set<Id>();
    	for(Visit_Report__c obj : Database.Query(mainQuery)){
			for(Visit_Report__Share objShr: obj.Shares){
				usrIds.add(objShr.UserOrGroupId);
			}
    	}
    	return usrIds;	
    }
    public static Set<Id> getVRIshareList( String mainQuery,String recordId){
    	Set<Id> usrIds = new Set<Id>();
    	for(Visit_Report_Item__c obj : Database.Query(mainQuery)){
			for(Visit_Report_Item__Share objShr: obj.Shares){
				usrIds.add(objShr.UserOrGroupId);
			}
    	}
    	return usrIds;	
    }
    public static Set<Id> getMIshareList( String mainQuery,String recordId){
    	Set<Id> usrIds = new Set<Id>();
    	for(Market_Intelligence__c obj : Database.Query(mainQuery)){
			for(Market_Intelligence__Share objShr: obj.Shares){
				usrIds.add(objShr.UserOrGroupId);
			}
    	}
    	return usrIds;	
    }
    public static Set<Id> getOpportunityshareList( String mainQuery,String recordId){
    	Set<Id> usrIds = new Set<Id>();
    	for(Opportunity obj : Database.Query(mainQuery)){
			for(OpportunityShare objShr: obj.Shares){
				usrIds.add(objShr.UserOrGroupId);
			}
    	}
    	return usrIds;	
    }
    public static List<ShareNotifyWrapper> getVRshare( String mainQuery,String recordId){
    	listShare = new List<ShareNotifyWrapper>();
    	for(Visit_Report__c obj : Database.Query(mainQuery)){
			for(Visit_Report__Share objShr: obj.Shares){
				System.debug('objShr-->'+objShr);
				tempShare = new ShareNotifyWrapper();
				tempShare.parentId = objShr.ParentId;
				tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
				tempShare.accessLevel = objShr.AccessLevel;
				tempShare.recId = objShr.Id;
				
				if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
					tempShare.grp = 'Group';
				}else{
					tempShare.grp = 'User';
				}
				if(objShr.RowCause == 'Manual'){
					tempShare.manual = true;
				}
				listShare.add(tempShare);
			}
		}
		return listShare;
    }
    public static List<ShareNotifyWrapper> getVRIshare( String mainQuery,String recordId){
    	listShare = new List<ShareNotifyWrapper>();
    	for(Visit_Report_Item__c  obj : Database.Query(mainQuery)){
			for(Visit_Report_Item__Share objShr: obj.Shares){
				System.debug('objShr-->'+objShr);
				tempShare = new ShareNotifyWrapper();
				tempShare.parentId = objShr.ParentId;
				tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
				tempShare.accessLevel = objShr.AccessLevel;
				tempShare.recId = objShr.Id;
				
				if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
					tempShare.grp = 'Group';
				}else{
					tempShare.grp = 'User';
				}
				if(objShr.RowCause == 'Manual'){
					tempShare.manual = true;
				}
				listShare.add(tempShare);
			}
		}
		return listShare;
    }
    public static List<ShareNotifyWrapper> getMIshare(String mainQuery,String recordId){
    	listShare = new List<ShareNotifyWrapper>();
    	for(Market_Intelligence__c obj : Database.Query(mainQuery)){
			for(Market_Intelligence__Share objShr: obj.Shares){
				System.debug('objShr-->'+objShr);
				tempShare = new ShareNotifyWrapper();
				tempShare.parentId = objShr.ParentId;
				tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
				tempShare.accessLevel = objShr.AccessLevel;
				tempShare.recId = objShr.Id;
				
				if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
					tempShare.grp = 'Group';
				}else{
					tempShare.grp = 'User';
				}
				if(objShr.RowCause == 'Manual'){
					tempShare.manual = true;
				}
				listShare.add(tempShare);
			}
		} 
		return listShare;
    }
     public static List<ShareNotifyWrapper> getOpportunityshare(String mainQuery,String recordId){
     	listShare = new List<ShareNotifyWrapper>();
    	for(Opportunity obj : Database.Query(mainQuery)){
			for(OpportunityShare objShr: obj.Shares){
				System.debug('objShr-->'+objShr);
				tempShare = new ShareNotifyWrapper();
				tempShare.parentId = objShr.OpportunityId;
				tempShare.name = idWithNameMap.get(objShr.UserOrGroupId);
				tempShare.accessLevel = objShr.OpportunityAccessLevel;
				tempShare.recId = objShr.Id;
				
				if(objShr.UserOrGroupId.getSObjectType().getDescribe().getName() == 'Group'){
					tempShare.grp = 'Group';
				}else{
					tempShare.grp = 'User';
				}
				if(objShr.RowCause == 'Manual'){
					tempShare.manual = true;
				}
				
				listShare.add(tempShare);
			}
		}
		return listShare;
    }
    public class ShareNotifyWrapper{
    	@AuraEnabled public String recId{get;set;}
    	@AuraEnabled public String parentId{get;set;}
    	@AuraEnabled public String name{get;set;}
    	@AuraEnabled public String UserOrGroupId{get;set;}
    	@AuraEnabled public String grp{get;set;}
    	@AuraEnabled public Boolean notify{get;set;}
    	@AuraEnabled public Boolean manual{get;set;}
    	@AuraEnabled public String accessLevel{get;set;}
    	public ShareNotifyWrapper(){
    		parentId = '';
    		recId = '';
	    	name = '';
	    	grp = '';
	    	notify = false;
	    	manual = false;
	    	AccessLevel = '';
	    }
    }
}