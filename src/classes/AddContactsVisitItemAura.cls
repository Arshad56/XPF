public with sharing class  AddContactsVisitItemAura {
    
    //get the existing contacts 
    @AuraEnabled
    public static String getContacts(Id visitReportId){
        Visit_Report_Item__c visitReport = [SELECT Id, Contact_s__c, Contact_Ids__c
                                            FROM Visit_Report_Item__c
                                            WHERE Id =:visitReportId LIMIT 1];
      
         return visitReport.Contact_Ids__c;
        
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
    public static string addContacts(String visitId, string conId) {
        try{
            List<string> contactIdList = new List<string>();
            integer iConId = 0;
            if(conId != NULL)
                contactIdList = conId.split(';');
            else
                iConId = 1;
            if(iConId == 1) 
                return 'Error';
            
            Visit_Report_Item__c visitReportItm = [SELECT Id, Contact_s__c, Contact_Ids__c
                                                   FROM Visit_Report_Item__c 
                                                   WHERE Id =:visitId LIMIT 1];
            
            string contactNames='';
            if(contactIdList.size()>0){
                for(contact con : [SELECT Id, Name FROM Contact WHERE Id IN :contactIdList])
                    contactNames += con.Name+';';
                
                contactNames = contactNames.removeEnd(';');
                if(visitReportItm.Contact_s__c==null)
                    visitReportItm.Contact_s__c ='';
                else
                    visitReportItm.Contact_s__c +=';';
            }
            
            if(visitReportItm.Contact_s__c==NULL)
                visitReportItm.Contact_s__c = '';
            
            visitReportItm.Contact_s__c =contactNames;
            visitReportItm.Contact_Ids__c = conId;
            update visitReportItm;
            return 'SUCCESS';
            
        }
        catch(DMLexception e){
            return 'Error :'+e.getMessage();
        }
    }
    
}