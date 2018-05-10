({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAllVRI");
		console.log('component.get("v.recordId")-->'+component.get("v.recordId"));
            action.setParams({
                "vrId": component.get("v.recordId"),
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+JSON.stringify(response));
                if (state === "SUCCESS") {
                    // if response if success then Close the Quick Action
                    var lsList = JSON.parse(response.getReturnValue());
            		component.set("v.vrItemList",lsList);
                }else if(state === "ERROR"){
                	alert('Error Occured!!');
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
	}
})