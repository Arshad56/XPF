({
    createObjectData: function(component, event, noRows) {
        var dealId  = component.get("v.recordId");
       console.log("createObjectData Roattion Pair Object");
        console.log("v.action"+ component.get("v.rpWrapper"));
        
        var RowItemList = component.get("v.rpWrapper");
        var rpWrapperInstance = component.get("v.rpWrapperInstance");
        for (var indexVar = 1; indexVar <= parseInt(noRows); indexVar++) {
        	var rpRec = 
	        RowItemList.push({
	        "rpRec": {'sobjectType': 'Service_Rotation_Detail__c','Currency_Code__c':'USD'},
            "listRD": [{'sobjectType': 'Service_Rotation_Detail__c'},{'sobjectType': 'Service_Rotation_Detail__c'}]
            });
	    }
        component.set("v.rpWrapper", RowItemList);
    },
    sumRows: function(component, svrList) {
    	var totalGive = 0;
		var totalTake = 0;
		for(var i = 0; i < svrList.length; i++){
    		if(svrList[i].rpRec.Volume_Teus__c != null && svrList[i].rpRec.Volume_Teus__c > 0 
    		  && svrList[i].rpRec.Req_Rate__c != null && svrList[i].rpRec.Req_Rate__c > 0)
    			if(svrList[i].rpRec.Arrangement__c == 'XPF to Customer' || svrList[i].rpRec.Arrangement__c == null){
    				totalGive += svrList[i].rpRec.Volume_Teus__c * svrList[i].rpRec.Req_Rate__c;
    			}else if(svrList[i].rpRec.Arrangement__c == 'Customer to XPF'){
    				totalTake += svrList[i].rpRec.Volume_Teus__c * svrList[i].rpRec.Req_Rate__c;
    			}
    	}
    	component.set("v.totalGive", totalGive);
    	component.set("v.totalTake", totalTake);
    }
})