@isTest
public class ManageServicesControllerTest {
    
    static testMethod void testAttendees(){
        
        contact con = new contact();
        con.LastName = 'Li Man';
        con.Email = 'test@gmail.com';
        con.MobilePhone = '8745987412';
        con.Phone = '+011-563214';
        //insert con;
        
        Service__c service = new Service__c();
        service.name = 'svc1';
        insert service;
        
        service = new Service__c();
        service.name = 'svc2';
        insert service;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama11111.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        
        Visit_Report__c visitReport = new Visit_Report__c();
        visitReport.Contact_s__c = con.Name;
        visitReport.XPF_Attendees__c = u.name;
       
        
        
        Visit_Report_Item__c vri = new Visit_Report_Item__c();
        vri.Discussed_Service__c = 'the services will continue;test';
        //vri.Visit_Report_ID__c = visitReport.id;
        
       
                
        Test.startTest();
        insert con;
        insert visitReport;
        insert vri;
        insert u;
        
        String srvc = 'svc1;svc2;';
        ManageServicesController.getServices(vri.id);
        ManageServicesController.updateServices(vri.id, srvc);
        ManageServicesController.showErroMsg(vri.id);
        Test.stopTest();
    }
}