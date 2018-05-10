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
		component.set("v.vrShare.UserOrGroupId", "");
    },
    doInit : function(component, event, helper) {},
    addItemInTable : function(component, event, helper) {
		var vrShare = component.get("v.vrShare.UserOrGroupId");
		console.log('vshare-->'+vrShare);
		if(vrShare){
			//alert('Change in Lookup -->'+vrShare);
			var listShare = component.get("v.shareList");
			console.log("addItemInTable listShare-->"+listShare);
	        
	        var action = component.get("c.initShareCard");
	        action.setParams({
	            "groupUserId": vrShare,
	            "shareListJSON": JSON.stringify(listShare),
	            parent : component.get("v.recordId")
	        });
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            console.log(state);
	            if (state === "SUCCESS") {
	            	console.log('response--> '+response.getReturnValue());
	                component.set("v.shareList", response.getReturnValue());
	                console.log(component.get("v.shareList"));
	                component.set("v.vrShare.UserOrGroupId", "");
	            }
	         });
	         $A.enqueueAction(action);
		}
    },
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.shareList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.shareList", AllRowsList);
    } ,
     saveShare : function(component, event, helper) {
     console.log('save share->');
    	 helper.saveRecord(component);
     }
})