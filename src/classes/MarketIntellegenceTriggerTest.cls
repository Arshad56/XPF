@isTest
public class MarketIntellegenceTriggerTest {
    
    static testMethod void tesMarket(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Manager' LIMIT 1]; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com123654');
        insert u;
        
        Market_Intelligence__c mi = new Market_Intelligence__c();
        mi.Type__c = 'Customer';
        mi.Remarks__c = 'test remark';
        insert mi;
        
        
        Market_Intelligence__Share share = new Market_Intelligence__Share();
        share.AccessLevel = 'Read';
        share.ParentId = mi.id;
        share.UserOrGroupId = u.id;
        insert share;
        
        Market_Intelligence__c mi1 = new Market_Intelligence__c();
        mi1.Type__c = 'Customer';
        mi1.Remarks__c = 'test remark';
        mi1.Parent_Id__c = mi.id;
        insert mi1;
        
    }
}