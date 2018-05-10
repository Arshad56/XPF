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
		component.set("v.expShr.UserOrGroupId", "");
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.initExpShareList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.expShareList", response.getReturnValue());
            }
         });
         $A.enqueueAction(action); 
    },
    addItemInTable : function(component, event, helper) {
		var expShr = component.get("v.expShr.UserOrGroupId");
		console.log('mexpShr'+expShr);
		if(expShr){
			//alert('Change in Lookup -->'+expShr);
			var listShare = component.get("v.expShareList");
	        console.log(component.get("v.expShareList"));
	        
	        var action = component.get("c.initExpShareCard");
	        action.setParams({
	            "groupUserId": expShr,
	            "expShareListJSON": JSON.stringify(listShare),
	            "parentId" : component.get("v.recordId")
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            console.log(state);
	            if (state === "SUCCESS") {
	            	console.log('response--> '+response.getReturnValue());
	                component.set("v.expShareList", response.getReturnValue());
	                console.log(component.get("v.expShareList"));
	                component.set("v.expShr.UserOrGroupId", "");
	            }
	         });
	         $A.enqueueAction(action);
	         
		}
    },
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.expShareList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.expShareList", AllRowsList);
    }  
})