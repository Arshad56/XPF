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
        
         var conIdAction = component.get("c.getServices");
         conIdAction.setParams({
            "visitReportId": component.get("v.recordId")
        });
        
        conIdAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                component.set("v.servicesId", response.getReturnValue());
            }
        });
         $A.enqueueAction(conIdAction);
    },
    
      saveRecord: function (component, event, helper) {
       console.log('component.get("v.recordId")-->'+component.get("v.recordId"));
      console.log('component.get("v.servicesId")-->'+component.get("v.servicesId"));
        var action = component.get("c.updateServices");
        action.setParams({
            "visitId": component.get("v.recordId"),
            "services" :component.get("v.servicesId")
        });
        
        action.setCallback(this, function(response){
            var res=response.getReturnValue()
            if(res=="SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "Service(s) have been updated successfully!",
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
                    "message": "Please choose at least one Service!",
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