@isTest
public class BulkPortPair_ControllerTest {
    
    static testMethod void test(){
        opportunity opp = new opportunity();
        opp.StageName = 'Closed Won';
        opp.name = 'Test TMC AS';
        opp.closeDate = system.today();
        insert opp;
       
        port__c p = new Port__c();
        p.Name = 'Ajman';
        p.Port_Code_External_ID__c = 'AEAJM';
        insert p;
        
        Terminal__c t = new Terminal__c();
        t.Port_Code__c = p.id;
        insert t;
        
        List<Port_Pair__c> listPortPairs = new List<Port_Pair__c>();
        Port_Pair__c portPair = new Port_Pair__c();
        portPair.Decision__c = 'Good to Have';
        portPair.deal_Name__c = opp.Id;
        portPair.RV__c = true;
        portPair.Port_of_Discharge__c = p.id;
        portPair.Terminal_of_Discharge__c = t.id;
        portPair.Terminal_of_Loading__c = t.id;
        portPair.Service__c = 'daily';
        portPair.Arragement__c = 'XPF to Customer';
        portPair.Port_of_Loading__c = p.id;
        listPortPairs.add(portPair);
        insert listPortPairs;
       
        Service_Rotation__c serRot = new Service_Rotation__c();
        serRot.arrangement__c = 'XPF to Customer';
        serRot.Deal__c = opp.id;
        serRot.Service__c = 'test';
        serRot.Remarks__c = 'test remark';
        serRot.Weight__c = 10.0;
        serRot.Volume_Teus__c = 30.0;
        serRot.Req_Rate__c = 200;
       //nsert serRot;
        
        List<Service_Rotation_Detail__c> listRD = new List<Service_Rotation_Detail__c>();
        Service_Rotation_Detail__c obj = new Service_Rotation_Detail__c();
        obj.Service_Rotation__c = serRot.id;
        obj.Port__c = p.id;
        obj.Terminal__c = t.id;
        obj.Remarks__c = 'ervice is good';
        listRD.add(obj);
        //insert listRD;
        
        
        string portJson = JSON.serialize(listPortPairs);
        string rotatJson = JSON.serialize(listRD);
        List<BulkPortPair_Controller.RPWrapper> wrapList = new List<BulkPortPair_Controller.RPWrapper>();
        BulkPortPair_Controller.RPWrapper wrap = new BulkPortPair_Controller.RPWrapper();
        wrap.rpRec = serRot;
        wrap.listRD = listRD;
        wrapList.add(wrap);
        string wrapjson = JSON.serialize(wrapList);
     
         //String srvc = 'svc1;svc2;';
        BulkPortPair_Controller.checkboxChecked(portJson);
        BulkPortPair_Controller.addPortPair(portJson,'5',opp.id);
        BulkPortPair_Controller.savePortPairs(opp.id, portJson, wrapjson);
        BulkPortPair_Controller.showErroMsg(opp.id);
        BulkPortPair_Controller.getServiceRotations(opp.id);
        BulkPortPair_Controller.getPortPairs(opp.id);
        //BulkPortPair_Controller.getServices(srvc, nameAndId);
    }
}