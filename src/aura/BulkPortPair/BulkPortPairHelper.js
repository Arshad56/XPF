({
    createObjectData: function(component, event, noRows) {
        var dealId  = component.get("v.recordId");
        var RowItemList = component.get("v.portPairList");
        for (var indexVar = 1; indexVar <= parseInt(noRows); indexVar++) {
	        RowItemList.push({
	            'sobjectType': 'Port_Pair__c',
	            'Service__c':'',
	            'Deal_Name__c': dealId,
	            'Currency_Code__c':'USD',
	        }); 
	    }
        component.set("v.portPairList", RowItemList);
    },
    sumRows: function(component, ppList) {
    	var totalGive = 0;
		var totalTake = 0;
		for(var i = 0; i < ppList.length; i++){
    		if(ppList[i].Volume_Teus__c != null && ppList[i].Volume_Teus__c > 0 
    		  && ppList[i].Req_Rate__c != null && ppList[i].Req_Rate__c > 0)
    			if(ppList[i].Arragement__c == 'XPF to Customer' || ppList[i].Arragement__c == null){
    				totalGive += ppList[i].Volume_Teus__c * ppList[i].Req_Rate__c;
    			}else if(ppList[i].Arragement__c == 'Customer to XPF'){
    				totalTake += ppList[i].Volume_Teus__c * ppList[i].Req_Rate__c;
    			}
    	}
    	console.log('totalGive-->'+totalGive);
    	console.log('totalTake-->'+totalTake);
    	component.set("v.totalGive", totalGive);
    	component.set("v.totalTake", totalTake);
    }
})