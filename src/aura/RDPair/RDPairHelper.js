({
	createObjectData: function(component, event, noRows) {
        //var dealId  = component.get("v.recordId");
        console.log('createObjectData of RD pair');
       // console.log("v.action"+ component.get("v.rdList"));
        
       // var RowItemList = component.get("v.rdList") || [];
        var RowItemList = component.get("v.rdList")|| [];
        console.log('RowItemList RD Pair--'+RowItemList);
        for (var indexVar = 1; indexVar <= parseInt(noRows); indexVar++) {
	        RowItemList.push({
	            'sobjectType': 'Service_Rotation_Detail__c'
	        });
	    }
        //component.set("v.rdList", RowItemList);
        console.log('RowItemList--'+component.get("v.rdList"));
    },
})