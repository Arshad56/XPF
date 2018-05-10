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
		component.set("v.miShr.UserOrGroupId", "");
    },
    doInit : function(component, event, helper) {
        var action = component.get("c.initMIShareList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.miShareList", response.getReturnValue());
            }
         });
         $A.enqueueAction(action); 
    },
    addItemInTable : function(component, event, helper) {
		var miShr = component.get("v.miShr.UserOrGroupId");
		console.log('miShr'+miShr);
		if(miShr){
			//alert('Change in Lookup -->'+miShr);
			var listShare = component.get("v.miShareList");
	        console.log(component.get("v.miShareList"));
	        
	        var action = component.get("c.initMIShareCard");
	        action.setParams({
	            "groupUserId": miShr,
	            "miShareListJSON": JSON.stringify(listShare),
	            "parentId" : component.get("v.recordId")
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            console.log(state);
	            if (state === "SUCCESS") {
	            	console.log('response--> '+response.getReturnValue());
	                component.set("v.miShareList", response.getReturnValue());
	                console.log(component.get("v.miShareList"));
	                component.set("v.miShr.UserOrGroupId", "");
	            }
	         });
	         $A.enqueueAction(action);
	         
		}
    },
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.miShareList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.miShareList", AllRowsList);
    }  
})