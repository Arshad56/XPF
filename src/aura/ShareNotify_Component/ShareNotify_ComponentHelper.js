({
	callInit: function(component, action) {
		console.log('doInit--');
		var action = component.get("c.getShareList");
		action.setParams({
            recordId: component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log('response-->'+response.getReturnValue());
            if (state === "SUCCESS") {
            	var shrList = response.getReturnValue();
		       console.log('shrList.size-->'+shrList.length); 
			   console.log('shrList-->'+shrList);   
			   
			   component.set("v.isListView",true);
			   if(shrList.length > 0){
				   component.set("v.shareList",response.getReturnValue());
			   }else{
				   component.set("v.isListEmpty",true);
			   }
            }else if(state === "ERROR"){
            	alert('Error Occured!!');
            }
        });
        $A.enqueueAction(action);
        
        var isOwnerAct = component.get("c.getIsOwner");
		isOwnerAct.setParams({
            recordId: component.get("v.recordId"),
        });
        isOwnerAct.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log('response-->'+response.getReturnValue());
            if (state === "SUCCESS") {
			   component.set("v.isOwner",response.getReturnValue());
            }else if(state === "ERROR"){
            	alert('Error Occured!!');
            }
        });
        $A.enqueueAction(isOwnerAct);
        
    },
    saveRecord : function(component) {
		var shareList = component.get("v.shareList");
		
		console.log("addItemInTable shareList-->"+JSON.stringify(shareList)+ ' '+shareList.length+ ' - '+(shareList.length > 0));
	    if(shareList.length > 0){
	    	var action = component.get("c.saveRecords");
		    action.setParams({
		        "recordId": component.get("v.recordId"),
		        "shareListJSON": JSON.stringify(shareList),
		        "isUpdate" : true,
		        "removedIds":JSON.stringify(component.get("v.removedIds"))
		    });
		    console.log('SaveRecord111---');
		    action.setCallback(this, function(response) {
		        var state = response.getState();
		        console.log('response--> '+state);
		        var resp = response.getReturnValue();
		        if (state === "SUCCESS" && resp.startsWith('Success')) {
		        	var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Record Shared Successfully!!",
                        "type" : "success"
                    });
                    toastEvent.fire();
                     $A.get("e.force:closeQuickAction").fire();
		        }else{
		        	var toastEvent = $A.get("e.force:showToast");
	                toastEvent.setParams({
	                    "title": "Error!",
	                    "message": "1111111 "+resp,
	                    "type":"error"
	                });
	                toastEvent.fire();
	                $A.get("e.force:closeQuickAction").fire();
		        }
		     });
		     $A.enqueueAction(action);
	    }
	}
})