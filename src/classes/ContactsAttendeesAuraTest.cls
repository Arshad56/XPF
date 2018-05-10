@isTest
public class ContactsAttendeesAuraTest {
    
    static testMethod void testContactUser(){
        
        contact con = new contact();
        con.LastName = 'Li Man';
        con.Email = 'test@gmail.com';
        con.MobilePhone = '8745987412';
        con.Phone = '+011-563214';
        
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
        
        test.startTest();
        insert con;
        insert u;
        insert visitReport;
        ContactsAttendeesAura.addContactsAndAttendees(visitReport.id, con.id, u.id);
        ContactsAttendeesAura.addContactsAndAttendees(visitReport.id, 'con.id', 'u.id'); 
        ContactsAttendeesAura.showErroMsg(visitReport.id);
        ContactsAttendeesAura.getContacts(visitReport.id);
        ContactsAttendeesAura.getAttendese(visitReport.id);
        
        test.stopTest();
    }
}