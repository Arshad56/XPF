({
	init : function(component) {
		var action = component.get("c.initMIWrap");
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                if (state === "SUCCESS") {
				       component.set("v.miWrapper",response.getReturnValue());
				       component.set("v.miShareList",[]);
				       
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
	saveRecord : function(component, from) {
		console.log("from-->"+from);
		var action = component.get("c.saveMIWrap");
		var miWrap = component.get("v.miWrapper");
	    console.log("miWrap-->"+miWrap);
	    miWrap.miItem.Type__c =  component.get("v.miWrapper.miType");
    	miWrap.miItem.Visit_Report__c  =  component.get("v.recordId");
    	console.log("miWrap.miItem-->"+miWrap.miItem);
    	miWrap.listWrapShr = component.get("v.miShareList");
    	console.log("miWrap.listWrapShr-->"+miWrap.listWrapShr);
    	
    	if(!component.get("v.taskCheckbox")){
    		miWrap.taskUserList = '';
    	}
         action.setParams({
            "miWrapperJSON": JSON.stringify(miWrap),
        });
            
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log('response-->'+response);
            if (state === "SUCCESS") {
			    console.log('Save Operation-->'+response.getReturnValue());
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