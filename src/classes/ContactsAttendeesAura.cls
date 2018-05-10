public with sharing class ContactsAttendeesAura {
    
    
    @AuraEnabled
    public static String getContacts(Id visitReportId){
        Visit_Report__c visitReport = [SELECT Id, Contact_s__c, Contact_Ids__c
                                       FROM Visit_Report__c
                                       WHERE Id =:visitReportId LIMIT 1];
      
         return visitReport.Contact_Ids__c;
        
        
    }
    @AuraEnabled
    public static String getAttendese(Id visitReportId){
        Visit_Report__c visitReport = [SELECT Id, XPF_Attendee_Ids__c
                                       FROM Visit_Report__c
                                       WHERE Id =:visitReportId LIMIT 1];
      
         return visitReport.XPF_Attendee_Ids__c;
        
        
    }
     //method to check current login user has read only permission 
    @AuraEnabled
    public static Boolean showErroMsg(Id recordId){
        
        List<UserRecordAccess> userRecordAccesList = [SELECT RecordId, HasEditAccess,HasReadAccess,HasDeleteAccess FROM UserRecordAccess 
                                                      WHERE UserId = :userInfo.getUserId() AND RecordId = :recordId];
        
        UserRecordAccess userAccess = userRecordAccesList.get(0);
        if(userAccess.HasEditAccess)
            return false;
        else
            return true;

    }
    
    @AuraEnabled
    public static string addContactsAndAttendees(String visitId, string conId, string usrId) {
        try{
            List<string> contactIdList = new List<string>();
            List<string> userIdList = new List<string>();
            integer iConId = 0, iUsrId = 0;
            if(conId != NULL)
                contactIdList = conId.split(';');
            else
                iConId = 1;
            if(usrId != NULL)
                userIdList = usrId.split(';'); 
            else
                iUsrId = 1;
            if(iConId == 1 && iUsrId == 1) 
                return 'Error';
            
            Visit_Report__c visitReport = [SELECT Id, Contact_s__c, XPF_Attendees__c
                                           FROM Visit_Report__c WHERE Id =:visitId LIMIT 1];
            visitReport.XPF_Attendees__c='';
            visitReport.Contact_s__c ='';
            
            string userNames='',contactNames='';
            if(contactIdList.size()>0){
                for(contact con : [SELECT Id, Name FROM Contact WHERE Id IN :contactIdList])
                    contactNames += con.Name+';';
                
                contactNames = contactNames.removeEnd(';');
                
            }
            if(userIdList.size()>0){
                for(User usr : [SELECT Id, Name FROM User WHERE Id IN :userIdList])
                    userNames += usr.Name+';';
                
                userNames =userNames.removeEnd(';');
                
            }
            if(visitReport.Contact_s__c==NULL)
                visitReport.Contact_s__c = '';
            if(visitReport.XPF_Attendees__c==NULL)
                visitReport.XPF_Attendees__c = '';
                
            visitReport.XPF_Attendee_Ids__c = usrId;
            
            visitReport.Contact_s__c =contactNames;
            visitReport.Contact_Ids__c = conId;
            visitReport.XPF_Attendees__c +=userNames; 
            
            update visitReport;
            return 'SUCCESS';
            
        }
        catch(DMLexception e){
            return 'Error :'+e.getMessage();
        }
    }
    
}