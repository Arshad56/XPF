public class PortPair_Helper {
    
    public static void rollupPortPairRoatation(Set<Id> dealIds){
    	List<Opportunity> opptyList = [select id, (Select Id, Arragement__c,Total_Value__c,Port_Pair_Rotation__c From Port_Pairs__r) from Opportunity where id =:dealIds];
   		System.debug('opptyList-->'+opptyList);
   		List<Opportunity> updateOppty = new List<Opportunity>();
   		Integer give;
   		Integer take;
   		List<String> giveList;
   		List<String> takeList;
        for(Opportunity deal: opptyList) {
        	System.debug('deal.Port_Pairs__r-->'+deal.Port_Pairs__r.size());
        	give = 1;
   			take = 1;
   			giveList = new List<String>();
   			takeList = new List<String>();
   			deal.Total_Give_Port_Pair__c = 0;
   			deal.Total_Take_Port_Pair__c = 0;
            deal.Port_Pair_Rotation__c = '';
            for(Port_Pair__c pp: deal.Port_Pairs__r){
            	if(pp.Arragement__c == 'XPF to Customer'){
            		deal.Total_Give_Port_Pair__c += (pp.Total_Value__c != null)?pp.Total_Value__c:0;
            		giveList.add(give+'. '+Utility.formatFormula(pp.Port_Pair_Rotation__c)+'\n');
            		give++;
            	}else if(pp.Arragement__c == 'Customer to XPF'){
            		deal.Total_Take_Port_Pair__c += (pp.Total_Value__c != null)?pp.Total_Value__c:0;
            		takeList.add(take+'. '+Utility.formatFormula(pp.Port_Pair_Rotation__c)+'\n');
            		take++;
            	}
            }
            if(giveList.size() > 0){
            	deal.Port_Pair_Rotation__c += 'Give:\n';
            	deal.Port_Pair_Rotation__c += String.join(giveList, '');
            }
            if(takeList.size() > 0){
            	deal.Port_Pair_Rotation__c += 'Take:\n';
            	deal.Port_Pair_Rotation__c += String.join(takeList, '');
            }
            updateOppty.add(deal);
        }
        update updateOppty;
   		
    }
}