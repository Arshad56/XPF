({
    init : function(component) {
		var action = component.get("c.initExpWrap");
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                console.log('response-->'+response);
                if (state === "SUCCESS") {
				       component.set("v.expWrapper",response.getReturnValue());
				       
				       component.set("v.showFile",false);
				       component.set("v.showFile",true);
				       
				       component.set("v.expShareList",[]);

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
	saveDirect: function(component) {
        var expWrap = component.get("v.expWrapper");
	    expWrap.expItem.Type__c =  component.get("v.expWrapper.expType");
    	expWrap.expItem.Visit_Report__c  =  component.get("v.recordId");
    	expWrap.listWrapShr = component.get("v.expShareList");
    	console.log("expWrap.listWrapShr-->"+expWrap.listWrapShr);
    	
    	if(!component.get("v.taskCheckbox")){
    		expWrap.taskUserList = '';
    	}
    	
        var action = component.get("c.saveExpWrap");
        action.setParams({
            "expWrapperJSON": JSON.stringify(expWrap)
        });
        action.setStorable();
        
    	var fileUpload = confirm("Do you want to upload file for this Exp item?");
         if(fileUpload == true){ 
        	 component.set("v.fileUpload",true);
             component.getEvent("initExpList").setParams({"from" : "hideButtons"  }).fire();
         }else{
        	 if(component.get("v.from") == "Save"){
        		 component.getEvent("initExpList").setParams({"from" : component.get("v.from")  }).fire();
        	 }else{
        		 component.set("v.fileUpload",false);
        		 this.init(component)
        	 }
         }
    	console.log('---**---'); 
	    
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log( '--state--'+state);
            
            if (state === "SUCCESS") {
            	console.log('--component.get("v.from")--'+component.get("v.from"));
                console.log('--response.getReturnValue()--'+response.getReturnValue());
                component.getEvent("handleExpEvent").setParams({"from" : "save"  }).fire();
                component.set("v.ExpId",response.getReturnValue());
                
                console.log('--component.get("v.ExpId")--'+component.get("v.ExpId"));
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        console.log('--end of upload--');
        $A.enqueueAction(action);
    }  
	
})