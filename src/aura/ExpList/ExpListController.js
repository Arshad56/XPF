({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAllExp");
		console.log('VR-->'+component.get("v.recordId"));
            action.setParams({
                "vrId": component.get("v.recordId"),
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                if (state === "SUCCESS") {
                    // if response if success then Close the Quick Action
                    var lsList = JSON.parse(response.getReturnValue());
            		component.set("v.expItemList",lsList);
                }else if(state === "ERROR"){
                	alert('Error Occured!!');
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
	}
})