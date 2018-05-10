public class ServiceRotaion_Helper {
     public static void rollupPortServiceRoatation(Set<Id> dealIds){
    	List<Opportunity> opptyList = [select id, (Select Id, Arrangement__c,Total_Value__c,SVC_Rotation__c From Rotation_Pairs__r) from Opportunity where id =:dealIds];
   		System.debug('opptyList-->'+opptyList);
   		List<Opportunity> updateOppty = new List<Opportunity>();
   		Integer give;
   		Integer take;
   		List<String> giveList;
   		List<String> takeList;
        for(Opportunity deal: opptyList) {
        	System.debug('deal.Rotation_Pairs__r-->'+deal.Rotation_Pairs__r.size());
        	give = 1;
   			take = 1;
   			giveList = new List<String>();
   			takeList = new List<String>();
   			deal.Total_Give_Service_Rotation__c = 0;
   			deal.Total_Take_Service_Rotation__c = 0;
            deal.Service_Rotation__c = '';
            for(Service_Rotation__c svr: deal.Rotation_Pairs__r){
            	if(svr.Arrangement__c == 'XPF to Customer'){
            		deal.Total_Give_Service_Rotation__c += (svr.Total_Value__c != null)?svr.Total_Value__c:0;
            		giveList.add(give+'. '+Utility.formatFormula(svr.SVC_Rotation__c)+'\n');
            		give++;
            	}else if(svr.Arrangement__c == 'Customer to XPF'){
            		deal.Total_Take_Service_Rotation__c += (svr.Total_Value__c != null)?svr.Total_Value__c:0;
            		takeList.add(take+'. '+Utility.formatFormula(svr.SVC_Rotation__c)+'\n');
            		take++;
            	}
            }
            if(giveList.size() > 0){
            	deal.Service_Rotation__c += 'Give:\n';
            	deal.Service_Rotation__c += String.join(giveList, '');
            }
            if(takeList.size() > 0){
            	deal.Service_Rotation__c += 'Take:\n';
            	deal.Service_Rotation__c += String.join(takeList, '');
            }
            updateOppty.add(deal);
        }
        update updateOppty;
     }
}