trigger VRITrigger on Visit_Report_Item__c (after insert) {
    Set<Id> vriIds = new Set<Id>();
    String parentId = '';
    for(Visit_Report_Item__c vri : trigger.new)
        if(vri.Parent_Id__c != NULL){
            vriIds.add(vri.id);
            parentId = vri.Parent_Id__c;
        }
     
    List<Visit_Report_Item__share> vriShare = [SELECT Id, UserOrgroupId, AccessLevel FROM Visit_Report_Item__share
                                               WHERE ParentId =:parentId];
    
  
    List<Visit_Report_Item__share> vriShareList = new List<Visit_Report_Item__share>();
    if(vriIds.size() > 0){
        for(Visit_Report_Item__c vri : trigger.new)
          	for(Visit_Report_Item__share vrisha : vriShare){
                if(vrisha.userOrgroupId != userInfo.getUserId()){
                    Visit_Report_Item__share temp = new Visit_Report_Item__share();
                    temp.ParentId = vri.id;
                    temp.UserOrGroupId = vrisha.UserOrGroupId;
                    temp.AccessLevel = (vrisha.AccessLevel == 'All')?'Edit':vrisha.AccessLevel;
                    vriShareList.add(temp);
                }
            }
    }
    system.debug('>>>>>vriShareList>>>>>>>'+vriShareList);
     if(vriShareList.size() > 0)
         insert vriShareList;
    
}