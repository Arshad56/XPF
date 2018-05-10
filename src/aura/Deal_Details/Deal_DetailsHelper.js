({
	init : function(component) {
		var action = component.get("c.initDealWrap");
		action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            
            if (state === "SUCCESS") { 
			       
			       var resp = response.getReturnValue();
			       component.set("v.dealWrapper",resp);
			       console.log('response-->'+JSON.stringify(resp.listWrapShr));
			       component.set("v.dealShareList",resp.listWrapShr);
			       
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
		var action = component.get("c.saveDealWrap");
		var dealWrap = component.get("v.dealWrapper");
	    console.log("dealWrap-->"+dealWrap);
	    dealWrap.dealItem.StageName =  component.get("v.dealWrapper.StageName");
    	dealWrap.dealItem.Visit_Report_ID__c  =  component.get("v.recordId");
    	console.log("dealWrap.dealItem-->"+dealWrap.dealItem);
    	dealWrap.listWrapShr = component.get("v.dealShareList");
    	console.log("dealWrap.listWrapShr-->"+dealWrap.listWrapShr);
    	if(!component.get("v.taskCheckbox")){
    		dealWrap.taskUserList = '';
    	}
        action.setParams({
            "dealWrapperJSON": JSON.stringify(dealWrap),
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