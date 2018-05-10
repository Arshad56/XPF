trigger ServiceRotaion_Trigger on Service_Rotation__c (after delete, after insert, after undelete, after update) {
   Set<Id> dealIds = new Set<Id>();
   if(trigger.isInsert || trigger.isUndelete || trigger.isUpdate){
	   	for(Service_Rotation__c sr: trigger.new)
	   		if(sr.Deal__c != null)
	   			dealIds.add(sr.Deal__c);
   }else if(trigger.isDelete){
   	    for(Service_Rotation__c sr: trigger.old)
	   		if(sr.Deal__c != null)
	   			dealIds.add(sr.Deal__c);
   }
   System.debug('dealIds-->'+dealIds);
   if(dealIds.size()>0)
       ServiceRotaion_Helper.rollupPortServiceRoatation(dealIds);
}