@isTest
public class VRITriggerTest {
    
    static testMethod void testVri(){
        Test.startTest();
      
        
        Account acc = new Account();
        acc.name = 'test acc';
        insert acc;
        
        Visit_Report_Item__c vri = new Visit_Report_Item__c();
        vri.Account_Name__c = acc.id;
        insert vri;
        
        Visit_Report_Item__c vri1 = new Visit_Report_Item__c();
        vri1.Account_Name__c = acc.id;
        vri1.Parent_Id__c = vri.id;
        insert vri1;
        test.stopTest();
        
     }
    
}