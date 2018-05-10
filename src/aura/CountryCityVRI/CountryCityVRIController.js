({
    doInit: function(component, event, helper){
        var showError = component.get("c.showErroMsg");
        showError.setParams({
            "recordId": component.get("v.recordId")
        });
        showError.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                component.set("v.readAccess", response.getReturnValue());
            }
        });
        $A.enqueueAction(showError);
        
          var countryCityAction = component.get("c.getCountryCity");
			countryCityAction.setParams({
	            "recordId": component.get("v.recordId")
	        });
	        countryCityAction.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS") {
	            	console.log(JSON.stringify(response.getReturnValue()));
	            	var strList = response.getReturnValue();
	                component.set("v.country", strList[0]);
	                component.set("v.city", strList[1]);
	            }
	        });
	         $A.enqueueAction(countryCityAction);
    },
    
      saveRecord: function (component, event, helper) {
        var action = component.get("c.saveCountryCity");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "country" : component.get("v.country"),
            "city" :component.get("v.city") 
        });
        
        action.setCallback(this, function(response){
            var res=response.getReturnValue()
            if(res=="SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "Country and City have been updated successfully!",
                    "duration":1000
                });
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else{
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error!",
                    "type": "Error",
                    "message": "There is Error. Please contact your Adminstrator!",
                    "duration":1000
                });
                resultsToast.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    cancelHandle : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    }
})