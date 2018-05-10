({
	
   doInit: function(component, event, helper) {
    // create a Default RowItem [Contact Instance] on first time Component Load
    // by call this helper function  
        var showError = component.get("c.showErroMsg");
        showError.setParams({
            "dealId": component.get("v.recordId")
        });
        
        showError.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                component.set("v.readAcces", response.getReturnValue());
                helper.sumRows(component);
            }
        });
        $A.enqueueAction(showError);
   },
   sumrizeRow: function(component, event, helper) {
	   console.log('Summarize-- Main Com');
        helper.sumRows(component);
    },
    closeQuickAction: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
    }, 
    
    closePopUp: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    // function for save the Records 
    Save: function(component, event, helper) {
    	
        if(!helper.validateRequiredRP(component, event)){
        	console.log('Rotaion Pair has error');
        }else if(helper.validatePortPairEmpty(component, event) && helper.validateRotaionPairEmpty(component, event)){
            alert('Please fill atleast one row');
        }else if (!helper.validateRequiredPP(component, event)) {
        	console.log('Port Pair has error');
        }else{
        	console.log('SUCCESS!!! Save the record');
        	var action = component.get("c.savePortPairs");
            action.setParams({
                "portPairJSON": JSON.stringify(component.get("v.portPairList")),
                "rotationPairJSON": JSON.stringify(component.get("v.wrapperList")),
                "dealId": component.get("v.recordId")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                var resp = response.getReturnValue();
		        if (state === "SUCCESS" && resp.startsWith('Success')) {
                    // if response if success then Close the Quick Action
                    var toastEvent = $A.get("e.force:showToast");
				    toastEvent.setParams({ 
				        "title": "Success!",
				        "message": "The record has been created successfully.",
				        "type": "success"
				    });
				    toastEvent.fire();
				    $A.get('e.force:refreshView').fire();
				    $A.get("e.force:closeQuickAction").fire();
				     
                }else{
                	var toastEvent = $A.get("e.force:showToast");
	                toastEvent.setParams({
	                    "title": "Error!",
	                    "message": resp,
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