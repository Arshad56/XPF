public without sharing class XPFAttachmentAura {
    
    //get the List of files Whose Parent is XPF File. 
    @AuraEnabled
    public static List<Contentversion> getContentDocs(string xpfFileId){
        List <Id> cdIdSet = new List <Id>();
        if(xpfFileId!=NULL){
            for (ContentDocumentLink nextCDL : [SELECT ContentDocumentId FROM ContentDocumentLink 
                                                WHERE LinkedEntityId = :xpfFileId]) 
                cdIdSet.add(nextCDL.ContentDocumentId); 
        }
        
        List<Contentversion> conVersionList = new List<Contentversion>();
        if(cdIdSet.size()>0)
            conVersionList = [SELECT Id, Title, FileType,ContentModifiedDate,ContentSize
                              FROM Contentversion 
                              WHERE ContentDocument.Id IN :cdIdSet order by ContentModifiedDate DESC];
        
        
        return conVersionList;
    }
    
    //get the current login user who can upload the files.
    @AuraEnabled 
    public static Boolean getUser(Id recordId){
        User usr = [SELECT Profile.Name FROM User WHERE Id =:userInfo.getuserId()];
        System.debug('usr.Profile.Name-->'+usr.Profile.Name);
        Boolean canUpload = false;
        if(usr.Profile.Name == 'System Administrator'){
            canUpload = true;
        }else{
            for(XPF_File_Administrator__c xpf: [select id,User__c from XPF_File_Administrator__c where XPF_File__c =: recordId]){
                System.debug('xpf.User__c-->'+xpf.User__c);
                if(userInfo.getuserId() == xpf.User__c){
                    canUpload = true;
                    break;
                }
                System.debug('canUpload-->'+canUpload);
            }
        }
        return canUpload;
    }
    
}