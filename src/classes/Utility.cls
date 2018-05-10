public class Utility {
    public static String removeColon(String str){
    	str = (str != null)?str:'';
    	str = str.removeEnd(';');
    	str = str.removeEnd(';');
    	return str;
    }
    public static String formatFormula(String str){
    	str = (str != null)?str:'';
		str = str.trim();
		str = str.removeEnd('-');
		str = str.removeStart('-');
		str = str.trim();
		str = str.replace('- -','-');
		return str;
    }
    // Return users who belong to a group and its sub-groups.
	public static Set<Id> getUserIds(Id groupIds){
		String userType = Schema.SObjectType.User.getKeyPrefix();
		String groupType = Schema.SObjectType.Group.getKeyPrefix();
		set<Id> usersIdsInGroup= new set<Id>();
		set<Id> grpId = new set<Id>();
		set<Id> relatedId = new set<Id>();
		for(GroupMember gm : [SELECT Id, group.name, group.type, UserOrGroupId FROM GroupMember where group.id =: groupIds]){
		    if(((String)gm.UserOrGroupId).startsWithIgnoreCase(userType)){
		        usersIdsInGroup.add(gm.UserOrGroupId);
		    }else if(((String)gm.UserOrGroupId).startsWithIgnoreCase(groupType)){
		        /*This section is to handle the Roles added to the public group. 
		            To get the Role Id added we need to Query the sub group & relatedId gives the Role ID. 
		        */
		        grpId.add(gm.UserOrGroupId);
		    }
		}
		for(Group gp: [Select Id, RelatedId From Group where Id=:grpId]){
			if(gp.RelatedId != null){
				relatedId.add(gp.RelatedId);
			}
		}
        for(User roleUsers:[Select Id from User where UserRole.Id=: relatedId]){
        	usersIdsInGroup.add(roleUsers.Id);
        }
		return usersIdsInGroup;
	}
	public static void sendEmailShare(String recordId,String shareApi,Set<Id> userIds){
		String templateName;
		if(shareApi == 'Visit_Report__Share'){
			templateName = 'VR_Share_Notification';
		}else if(shareApi == 'Visit_Report_Item__Share'){
			templateName = 'VRI_Share_Notification';
		}else if(shareApi == 'OpportunityShare'){
			templateName = 'Deal_Share_Notification';
		}else if(shareApi == 'Market_Intelligence__Share'){
			templateName = 'MI_Share_Notification';
		}
		System.debug('templateName-->'+templateName);
		EmailTemplate emailTemplate= [select Id from EmailTemplate where DeveloperName  =: templateName];
	    List<Messaging.SingleEmailMessage> allEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage  tempmail;
        System.debug('userIds-->'+userIds);
        Contact con = [select id from Contact limit 1];
        system.debug('>>>con>>>>'+con);
        for(User usr : [Select Id,Email From User where id =: userIds]){
        	System.debug('usr-->'+usr);
           tempmail = new Messaging.SingleEmailMessage ();
           tempmail.toAddresses= new String[] { usr.Email };
           tempmail.setTreatTargetObjectAsRecipient(false);
           tempmail.setTargetObjectId(con.Id);
           tempmail.setWhatId(recordId);
           tempmail.setTemplateId(emailTemplate.id);  
           tempmail.setSaveAsActivity(false);
           
           allEmails.add(tempmail);           
           System.debug('tempmail-->'+tempmail);
        }
        System.debug('allEmails-->'+allEmails);
        Messaging.sendEmail(allEmails);
	}
}