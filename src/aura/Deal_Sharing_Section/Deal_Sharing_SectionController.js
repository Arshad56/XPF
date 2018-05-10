({
	changeLookup: function(component, event, helper) {
	console.log(component.get("v.picklistName"));
		component.set("v.objectName",component.get("v.picklistName"));
		if(component.get("v.picklistName") == 'Group'){
			component.set("v.subTitle","Name");
		}else{
			component.set("v.subTitle","Name");
		}
		//component.set("v.ShareLookup", !component.set("v.ShareLookup"));
		component.set("v.dealShr.UserOrGroupId", "");
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.initShareList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.dealShareList", response.getReturnValue());
            }
         });
         $A.enqueueAction(action); 
    },
    addItemInTable : function(component, event, helper) {
		var dealShr = component.get("v.dealShr.UserOrGroupId");
		console.log('dealShr'+dealShr);
		if(dealShr){
			//alert('Change in Lookup -->'+dealShr);
			var listShare = component.get("v.dealShareList");
	        console.log(component.get("v.dealShareList"));
	        
	        var action = component.get("c.initDealShareCard");
	        action.setParams({
	            "groupUserId": dealShr,
	            "dealShareListJSON": JSON.stringify(listShare),
	            "parentId" : component.get("v.recordId")
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            console.log(state);
	            if (state === "SUCCESS") {
	            	console.log('response--> '+response.getReturnValue());
	                component.set("v.dealShareList", response.getReturnValue());
	                console.log(component.get("v.dealShareList"));
	                component.set("v.dealShr.UserOrGroupId", "");
	            }
	         });
	         $A.enqueueAction(action);
	         
		}
    },
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.dealShareList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.dealShareList", AllRowsList);
    }  
})