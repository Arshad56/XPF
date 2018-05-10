({
	init : function(component) {
		var action = component.get("c.initVRIWrap");
			action.setParams({
                recordId: component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                if (state === "SUCCESS") {
                		var resp = response.getReturnValue();
				       component.set("v.vriWrapper",resp);
				      
				       component.set("v.vriShareList",resp.listWrapShr);
				       var childComponent = component.find("VR_DependentPicklist");
				       childComponent.initiate();
				       component.set("v.city","");
				       component.set("v.country","");
				       if(component.get("v.taskCheckbox")){
				    	   component.set("v.taskCheckbox",false);
				    	   var changeElement = component.find("followSect");
					       $A.util.toggleClass(changeElement, "slds-hide");
				       }
                }else if(state === "ERROR"){
                	alert('Error Occured!!');
                }
            });
            $A.enqueueAction(action);
	},
    
    validateFields: function(component){
    	console.log('validate1 --> ' + this.validateLookup(component.get("v.vriWrapper.vrItem.Account_Name__c")+''));
    	console.log('validate2 --> ' + !component.get("v.country") );
    	console.log('validate3 --> ' + !component.get("v.vriWrapper.vrItem.Agenda__c"));
        if(this.validateLookup(component.get("v.vriWrapper.vrItem.Account_Name__c")+'') || this.validateLookup(component.get("v.vriWrapper.vriConList")+'') || !component.get("v.country") || !component.get("v.city") || !component.get("v.vriWrapper.vrItem.Agenda__c") || !component.get("v.vriWrapper.vrItem.Feedback__c")){
	         alert('Please check all mandate fields.');
	         return false;
        } 
        if(component.get("v.taskCheckbox")){
        	if(!component.get("v.vriWrapper.taskInstance.Subject") || !component.get("v.vriWrapper.taskInstance.ActivityDate") || this.validateLookup(component.get("v.vriWrapper.taskUserList"))){
        		alert('Please check all mandate fields in a Task section.');
        		return false;
        	}
        }
        return true;
    },
    validateLookup: function(lookup) {
    	//console.log(lookup.length +'--lookup--'+lookup );
    	
    	if(undefined ==lookup || lookup == null){
    		return true; 
    	}else if(lookup.length < 15){
    		return true;
    	}
    	return false;
    },
	saveRecord : function(component, from) {
		var action = component.get("c.saveVRIWrap");
			var vriWrap = component.get("v.vriWrapper");
		    vriWrap.vrItem.Visit_Report_ID__c =  component.get("v.recordId");
		    
		    vriWrap.vrItem.Key_Country_Discussed__c =  component.get("v.country");
	    	vriWrap.vrItem.Key_City_Port_Discussed__c = component.get("v.city");
	    	vriWrap.listWrapShr = component.get("v.vriShareList");
	    	
	    	if(!component.get("v.taskCheckbox")){
	    		vriWrap.taskUserList = '';
	    	}
            action.setParams({
                "vriWrapperJSON": JSON.stringify(vriWrap),
            });
            
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                if (state === "SUCCESS") {
				    
				     if(from == 'SaveNew'){
				    	   this.init(component);
				       }
                }else if(state === "ERROR"){
                	alert('Error Occured!!');
                }
            });
            $A.enqueueAction(action);
	}
})