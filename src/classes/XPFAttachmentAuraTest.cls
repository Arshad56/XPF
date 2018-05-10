@isTest
public class XPFAttachmentAuraTest {
    
    static testMethod void testXPFattach(){
        //User usr = [SELECT Profile.Name FROM User WHERE Profile.Name !='System Administrator' Order by name desc LIMIT 1];
        
        Services_Files__c serviceFile = new Services_Files__c();
        serviceFile.Category__c = 'SAsia';
        
        XPF_File_Administrator__c fileAdmin = new XPF_File_Administrator__c();
        fileAdmin.User__c = UserInfo.getUserId();
        
        test.startTest();
        
        insert serviceFile;
        fileAdmin.XPF_File__c = serviceFile.id;
        insert fileAdmin;
       
        /*system.runAs(usr){
            fileAdmin.User__c = usr.id;
            XPFAttachmentAura.getUser(serviceFile.id);
        }*/
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body');         
        cv.VersionData =bodyBlob;          
        insert cv; 
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
		contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: cv.id].contentdocumentid;	
        contentlink.LinkedEntityId = serviceFile.id;
		contentlink.ShareType = 'V';
		insert contentlink;
			
        
        XPFAttachmentAura.getContentDocs(serviceFile.id);
        fileAdmin.User__c = UserInfo.getUserId();
        update fileAdmin;
        system.debug('fileAdmin>>>'+fileAdmin);
        XPFAttachmentAura.getUser(serviceFile.id);
        
        test.stopTest();        
    }
}