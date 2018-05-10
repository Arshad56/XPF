trigger PortPair_Trigger on Port_Pair__c (after delete, after insert, after undelete, after update, before update) {
  Set<Id> dealIds = new Set<Id>();
   if(trigger.isInsert || trigger.isUndelete || trigger.isUpdate){
	   	for(Port_Pair__c pp: trigger.new)
            if(pp.Deal_Name__c != null)
	   			dealIds.add(pp.Deal_Name__c);
   }else if(trigger.isDelete){
   	    for(Port_Pair__c pp: trigger.old)
	   		if(pp.Deal_Name__c != null)
	   			dealIds.add(pp.Deal_Name__c);
   }
   System.debug('dealIds-->'+dealIds);
   if(dealIds.size()>0)
   	   PortPair_Helper.rollupPortPairRoatation(dealIds);
}