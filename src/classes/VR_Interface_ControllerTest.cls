@isTest
public class VR_Interface_ControllerTest {
    
    static testMethod void testVR(){
        Account acc = new Account();
        acc.Name = 'test';
        
        contact con = new contact();
        con.LastName = 'test';
       
        
        Visit_Report__c vr = new Visit_Report__c();
        
        
        
        Visit_Report_Item__c vrItem = new Visit_Report_Item__c();
        vrItem.Visit_Report_ID__c = vr.id;
        vrItem.Contact_s__c = 'test';
        vrItem.Discussed_Service__c = 'test services';
        vrItem.Key_Country_Discussed__c = '--- None ---';
        vrItem.Account_Name__c = acc.id;
        //insert vrItem;
        
        Visit_Report_Item__c vrItem1 = new Visit_Report_Item__c();
        vrItem1.Visit_Report_ID__c = vr.id;
        vrItem1.Contact_s__c = 'test';
        vrItem1.Account_Name__c = acc.id;
        insert vrItem1;
        
        Market_Intelligence__c mi = new Market_Intelligence__c();
        mi.Visit_Report__c = vr.id;
        //insert mi;
        
        Expense_Item__c expItm = new Expense_Item__c();
        expItm.Visit_Report__c = vr.id;
        expItm.Date__c = system.today();
        //insert expItm;
        
        Multi_Country__c customSet = new Multi_Country__c();
        customSet.Name = 'ALGERIA';
        customSet.City_1__c = 'Algiers';
        customSet.City_2__c = 'Tbillisi';
        customSet.City_3__c = 'Brussels';
        customSet.City_4__c = 'Sydney';
        
        opportunity opp = new opportunity();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fixed Slot').getRecordTypeId();	
        opp.Visit_Report_ID__c = vr.id;
        opp.Name = 'test opp';
        opp.CloseDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
        opp.StageName = 'New/Lead';
        //insert opp;
        
        OpportunityShare oppShare = new OpportunityShare();
        oppShare.UserOrGroupId = [SELECT Id from group LIMIT 1].id;
        oppShare.OpportunityAccessLevel = 'Edit';
        
        test.startTest();
        List<VR_Interface_Controller.DealShareWrapper> dealShareWrapList = new  List<VR_Interface_Controller.DealShareWrapper>();
        VR_Interface_Controller.DealShareWrapper dealShareWrap = new VR_Interface_Controller.DealShareWrapper();
        dealShareWrap.dealShr = oppShare;
        dealShareWrap.name = 'test share';
        dealShareWrap.grp = 'group';
        dealShareWrapList.add(dealShareWrap);
        string dealShareJsonList = JSON.serialize(dealShareWrapList);
        string dealShareJson = JSON.serialize(dealShareWrap);
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t;
        
        insert acc;
        con.AccountId = acc.id;
        insert con;
        
        opp.AccountId = acc.id;
        oppShare.OpportunityId = opp.id;
        vr.Account_Name__c = acc.id;
        insert vr;
        insert customSet;
        Visit_Report_Item__Share visitShare = new Visit_Report_Item__Share();
        visitShare.ParentId = vrItem.id;
        visitShare.AccessLevel = 'All';
        
        Market_Intelligence__Share miIntShar = new Market_Intelligence__Share();
        miIntShar.ParentId = mi.id;
        
        Expense_Item__Share expItmShare = new Expense_Item__Share();
        expItmShare.ParentId = expItm.id;
        
        List<VR_Interface_Controller.DealShareWrapper> dealshareWrapList1 = new List<VR_Interface_Controller.DealShareWrapper>();
        VR_Interface_Controller.DealShareWrapper dealshareWrap1 = new VR_Interface_Controller.DealShareWrapper();
        dealshareWrap1.notify = true;
        dealshareWrap1.name = 'test';
        dealshareWrap1.dealShr = oppShare;
        dealshareWrapList1.add(dealshareWrap1);
        //dealshareWrap1.dealShr = opp;
        
        VR_Interface_Controller.DealWrapper dealWrap = new VR_Interface_Controller.DealWrapper();
        dealWrap.dealItem = opp;
        dealWrap.listWrapShr = dealshareWrapList1;
        dealWrap.rt = opp.RecordType.Name;
        dealWrap.taskUserList = String.valueOf(t.OwnerId);
        dealWrap.stageName = opp.StageName;
        dealWrap.taskInstance = t;
        string dealJson = JSON.serialize(dealWrap);
        
        VR_Interface_Controller.MIWrapper miWrap = new VR_Interface_Controller.MIWrapper();
        miWrap.miItem = mi;
        miWrap.taskUserList = String.valueOf(t.OwnerId);
        miWrap.taskInstance = t;
        miWrap.miType = 'port';
        String miJson = JSON.serialize(miWrap);
        
        VR_Interface_Controller.ExpWrapper expWrap = new  VR_Interface_Controller.ExpWrapper();
        expWrap.expItem = expItm;
        expWrap.taskUserList = String.valueOf(t.OwnerId);
        expWrap.taskInstance = t;
        expWrap.expType = 'phone';
        string expJson = JSON.serialize(expWrap);
        
        VR_Interface_Controller.VriWrapper vistReportWrap = new  VR_Interface_Controller.VriWrapper();
        vistReportWrap.vrItem = vrItem;
        vistReportWrap.taskInstance = t;
        vistReportWrap.taskUserList = String.valueOf(t.OwnerId);
        vistReportWrap.vriConList = vrItem.Contact_s__c; 
        
        List<VR_Interface_Controller.ShareWrapper> vrRshareWraplst = new List<VR_Interface_Controller.ShareWrapper>();
        VR_Interface_Controller.ShareWrapper vrRshareWrap = new VR_Interface_Controller.ShareWrapper();
        vrRshareWrap.vps = visitShare;
        vrRshareWrap.notify = true;
        vrRshareWrap.AccessLevel = visitShare.AccessLevel;
        vrRshareWraplst.add(vrRshareWrap);
        String shareJson = JSON.serialize(vrRshareWraplst);
        
        VR_Interface_Controller.MIWrapper miWrap1 = new VR_Interface_Controller.MIWrapper();
        miWrap1.miItem = mi;
        
        List<VR_Interface_Controller.MIShareWrapper> miIntSharWrapList = new List<VR_Interface_Controller.MIShareWrapper>();
        VR_Interface_Controller.MIShareWrapper  miIntSharWrap = new VR_Interface_Controller.MIShareWrapper();  
        miIntSharWrap.mis = miIntShar;
        miIntSharWrapList.add(miIntSharWrap);
        string miJson1 = JSON.serialize(miIntSharWrapList);
        
        
        List<VR_Interface_Controller.ExpShareWrapper> expShaWrap = new  List<VR_Interface_Controller.ExpShareWrapper>();
        string expJson1 = JSON.serialize(expShaWrap);
        
        VR_Interface_Controller.VriWrapper vriWrp = new VR_Interface_Controller.VriWrapper();
        vriWrp.vrItem = vrItem;
        vriWrp.taskInstance = t;
        vriWrp.taskUserList = String.valueOf(t.OwnerId);
        vriWrp.vriConList = vrItem.Contact_s__c;
        string vriJson = JSON.serialize(vriWrp);
        
        String groupId = [SELECT id, Name FROM Group where RelatedId=: userInfo.getUserRoleId() LIMIT 1].id;
        
        VR_Interface_Controller.showErroMsg(vr.id);
        VR_Interface_Controller.saveCountryCity(vrItem1.id, 'India', 'Agra');
        VR_Interface_Controller.getCountryCity(vrItem1.id);
         VR_Interface_Controller.getCountry(vrItem1.id);
        VR_Interface_Controller.getCity(vrItem1.id);
        VR_Interface_Controller.getAllVRI(vrItem.id);
        VR_Interface_Controller.getAllDeal(opp.id);
        VR_Interface_Controller.getAllMI(mi.id);
        VR_Interface_Controller.getAllExp(expItm.id);
        VR_Interface_Controller.getPickListValuesIntoList('opportunity', 'RecordType');
        VR_Interface_Controller.getPickListValuesIntoList('opportunity', 'type');
        VR_Interface_Controller.initShareList();
        VR_Interface_Controller.initShareCard(groupId, string.valueOf(vrItem.id), shareJson);
        VR_Interface_Controller.initDealShareCard(groupId, string.valueOf(opp.id), dealShareJsonList);
        VR_Interface_Controller.initMIShareCard(groupId, string.valueOf(mi.id), miJson1);
        VR_Interface_Controller.initExpShareCard(groupId, string.valueOf(expItm.id), expJson1);
        VR_Interface_Controller.initMIShareList();
        VR_Interface_Controller.initExpShareList();
        VR_Interface_Controller.getKeyCountries();
        VR_Interface_Controller.getKeyCities('ALGERIA');
        VR_Interface_Controller.saveDealWrap(dealJson);
        VR_Interface_Controller.saveMIWrap(miJson);
        VR_Interface_Controller.saveExpWrap(expJson, 'No File Selected', 'myfile.pdf', 'image', miWrap.miType);
        VR_Interface_Controller.initExpWrap(); 
        VR_Interface_Controller.initMIWrap();
       VR_Interface_Controller.initDealWrap(vr.id);
       VR_Interface_Controller.initVRIWrap(vr.id);
        VR_Interface_Controller.saveVRIWrap(vriJson);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(vr);
        RedirectToVP_Controller redirectObj = new RedirectToVP_Controller(sc);
        
        PageReference pageRef = Page.RedirectToVP;
        pageRef.getParameters().put('id', String.valueOf(vr.Id));
        Test.setCurrentPage(pageRef);
        
        
        
        test.stopTest();
    }
}