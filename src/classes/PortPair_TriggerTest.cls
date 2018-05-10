@isTest
public class PortPair_TriggerTest {

    static testMethod void testPortPair(){
        
        Account acc = new Account();
        acc.Name = 'test';
        
        opportunity deal = new opportunity();
        deal.Name = 'test opp';
        deal.CloseDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
        deal.StageName = 'New/Lead';
        deal.Service_Rotation__c = 'test rotation';
        deal.Svc_Rotation_Weight__c = 20.0;
        deal.Svc_Rotation_Rate__c = 10.0;
        deal.Svc_Rotation_Volume__c = 30.0;
       
        //port pair trigger test
        List<Port_Pair__c> pplist = new List<Port_Pair__c>();
        Port_Pair__c portP = new Port_Pair__c();
        portP.Arragement__c = 'Customer To XPF';
        
        Port_Pair__c portP1 = new Port_Pair__c();
        portP1.Arragement__c = 'XPF To Customer';
        
       
        //service rotation trigger test
        List<Service_Rotation__c> srList = new List<Service_Rotation__c>();
        Service_Rotation__c serRotat = new Service_Rotation__c();
        serRotat.Port_Rotations__c = 'test port';
        serRotat.Weight__c = 10.0;
        serRotat.Arrangement__c = 'Customer To XPF';
        serRotat.Req_Rate__c = 200;
        serRotat.Volume_Teus__c = 20.0;
        serRotat.Currency_Code__c = 'USD';
      
        
        Service_Rotation__c serRotat1 = new Service_Rotation__c();
        serRotat1.Arrangement__c = 'XPF To Customer';
        serRotat1.Port_Rotations__c = 'test port';
        serRotat1.Weight__c = 10.0;
        serRotat1.Req_Rate__c = 200;
        serRotat1.Volume_Teus__c = 20.0;
        serRotat1.Currency_Code__c = 'USD';
       
       
        test.startTest();
        insert acc;
        deal.AccountId = acc.id;
        insert deal;
        
        portP1.Deal_Name__c = deal.id;
        portP.Deal_Name__c = deal.id;
        pplist.add(portP1);
        pplist.add(portP);
        insert pplist;
        
        delete portP;
        serRotat.Deal__c = deal.id;
        serRotat1.Deal__c = deal.id;
        srList.add(serRotat1);
        srList.add(serRotat);
        insert srList;
        
        serRotat.Remarks__c = 'how was the service';
        update serRotat;
        
        delete serRotat;
        test.stopTest();
    }
}