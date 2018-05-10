@isTest
public class ContactTriggerTest {
    
    static testMethod void test(){
        
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jason.liveston@asdf.com789',
                            ProfileId = pro.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        
	        Account acc = new Account();
	        acc.Name = 'test';
	        //acc.OwnerId = userInfo.getUserId();
	        insert acc;
	     System.runAs(usr) {   
	        acc.OwnerId = usr.id;
	        update acc;
	        } 
	        contact con = new contact();
	        con.LastName = 'Corfitsen';
	        con.Email = 'test@gmail.com';
	        con.MobilePhone = '8721365478';
	        con.Phone = '9845789654';
	        con.OwnerId = UserInfo.getUserId();
	        insert con;
	       System.runAs(usr) {     
	        con.OwnerId = usr.id;
	        update con;
	       }
       
    }
}