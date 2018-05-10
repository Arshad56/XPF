({
	saveRecord : function(component) {
		var shareList = component.get("v.shareList");
		
		console.log("addItemInTable shareList-->"+shareList);
	    if(shareList.length > 0){
	    	var action = component.get("c.saveRecords");
		    action.setParams({
		        "recordId": component.get("v.recordId"),
		        "shareListJSON": JSON.stringify(shareList),
		        "isUpdate" : false
		    });
		    action.setCallback(this, function(response) {
		        var state = response.getState();
		        console.log('response--> '+state);
		        var resp = response.getReturnValue();
		        if (state === "SUCCESS" && resp.startsWith('Success')) {
		        	/*var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Record Shared Successfully!!",
                        "type" : "success"
                    });
                    toastEvent.fire();
                     $A.get("e.force:closeQuickAction").fire();*/
		        }else{
		        	var toastEvent = $A.get("e.force:showToast");
	                toastEvent.setParams({
	                    "title": "Error!",
	                    "message": "2222222 "+resp,
	                    "type":"error"
	                });
	                toastEvent.fire();
	                $A.get("e.force:closeQuickAction").fire();
		        }
		     });
		     $A.enqueueAction(action);
	    }else{
	    	//alert('Please select atleast one User/Group.');
	    }
	    
	}
})