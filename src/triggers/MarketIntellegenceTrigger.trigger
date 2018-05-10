trigger MarketIntellegenceTrigger on Market_Intelligence__c (After insert) {
    Set<Id> miId = new Set<Id>();
    String parentId = '';
    for(Market_Intelligence__c mi : Trigger.new){
        if(mi.Parent_Id__c != NULL){
            miId.add(mi.id);
            parentId = mi.Parent_Id__c;
        }
    }
    List<Market_Intelligence__Share> marktSareList = [SELECT Id, UserOrGroupId, RowCause,AccessLevel  
                                                      FROM Market_Intelligence__Share
                                                      WHERE ParentId = :parentId];
    
    system.debug('marktSareList>>>>'+marktSareList);
    List<Market_Intelligence__Share> marketSaherList = new List<Market_Intelligence__Share>();
    if(miId.size() > 0){
        for(Market_Intelligence__c mi : trigger.new){
            for(Market_Intelligence__Share marktSare : marktSareList){
                system.debug('marktSare.UserOrGroupId>>'+marktSare.UserOrGroupId);
            	if(marktSare.UserOrGroupId != userInfo.getUserId()){
            		Market_Intelligence__Share temp = new Market_Intelligence__Share();
	                temp.ParentId = mi.id;
	                temp.UserOrGroupId = marktSare.UserOrGroupId;
	                temp.AccessLevel =  (marktSare.AccessLevel == 'All')?'Edit':marktSare.AccessLevel;
	                //temp.RowCause = marktSare.RowCause;//Schema.Market_Intelligence__Share.RowCause.Manual;

	                marketSaherList.add(temp);
            	}
            }
        }
        system.debug('marketSaherList>>>>>>'+marketSaherList);
        if(marketSaherList.size() > 0)
            insert marketSaherList;
    }
}