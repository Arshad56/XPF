@isTest
public class ShareNotify_ControllerTest {
    
    static testMethod void tesShare(){
        Visit_Report__c vr = new Visit_Report__c();
        vr.Status__c  = 'Draft';
        //insert vr;
        
        account acc = new account();
        acc.Name = 'tmc';
        //insert acc;
        
        contact con = new contact();
        con.LastName = 'test';
        //con.AccountId = acc.id;
        //insert con;
        
        Visit_Report_Item__c vri = new Visit_Report_Item__c();
        //vri.Visit_Report_ID__c = vr.id;
        //vri.Account_Name__c = acc.id;
        //insert vri;
        
        Market_Intelligence__c mi = new Market_Intelligence__c();
        mi.Type__c = 'Customer';
        mi.Remarks__c = 'test remark';
        //insert mi;
        
        opportunity opp = new opportunity();
        opp.Name = 'TMC - SS - 42018 - SKX';
        opp.Deal_Name_Suffix__c = 'SKX';
        //opp.AccountId = acc.id;
        opp.CloseDate = system.today();
        opp.StageName = 'closed Won';
        opp.Hub__c = 'East Asia';
        //insert opp;
        
        List<ShareNotify_Controller.ShareNotifyWrapper> wrapList = new List<ShareNotify_Controller.ShareNotifyWrapper>();
        ShareNotify_Controller.ShareNotifyWrapper wrap = new ShareNotify_Controller.ShareNotifyWrapper();
        wrap.parentId = vr.id;
        wrap.accessLevel = 'Edit';
        wrap.name = 'Visit_Report__Share';
        wrap.notify = true;
        wrap.UserOrGroupId = [select id from user  where profile.Name!='System Administrator' order by name desc limit 1].id;
        wrapList.add(wrap);
        String serialWrap = JSON.serialize(wrapList);
        
        Test.startTest();
        insert vr;
        insert acc;
        con.AccountId = acc.id;
        insert con;
        
        vri.Visit_Report_ID__c = vr.id;
        vri.Account_Name__c = acc.id;
        insert vri;
        
        insert mi;
        opp.AccountId = acc.id;
        insert opp;
        ShareNotify_Controller.saveRecords(vr.id, serialWrap);
        ShareNotify_Controller.getIsOwner(vr.id);
        ShareNotify_Controller.getShareList(vr.id);
        string vrString  = 'select Id, name from visit_report__c';
        string vristring = 'select id,name from visit_report_item__c';
        string miShare = 'select id, name from Market_Intelligence__c';
        string dealShare = 'select id, name from opportunity ';
        ShareNotify_Controller.getVRshare(vrString ,vr.id);
        ShareNotify_Controller.getVRshareList(vrString ,vr.id);
        
        
        //ShareNotify_Controller.getIsOwner(vri.id);
        ShareNotify_Controller.saveRecords(vri.id, serialWrap);
        ShareNotify_Controller.getShareList(vri.id);
        ShareNotify_Controller.getVRIshare(vristring, vri.id);
        ShareNotify_Controller.getVRIshareList(vristring, vri.id);
        
        ShareNotify_Controller.saveRecords(mi.id, serialWrap);
        ShareNotify_Controller.getShareList(mi.id);
        ShareNotify_Controller.getMIshare(miShare, mi.id);
        ShareNotify_Controller.getMIshareList(miShare, mi.id);
        
        ShareNotify_Controller.saveRecords(mi.id, serialWrap);
        ShareNotify_Controller.getShareList(opp.id);
        ShareNotify_Controller.getOpportunityshare(dealshare, opp.id);
        ShareNotify_Controller.getOpportunityshareList(dealshare, opp.id);
        ShareNotify_Controller.initShareCard(Userinfo.getUserId(), vri.id, serialWrap);
        
        //test coverage for Utility class
        Utility.removeColon('str1;str2');
        Utility.formatFormula('-12-45');
        Utility.getUserIds(userInfo.getUserId());
        Test.stopTest();
        
    }
    
}