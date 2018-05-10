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
        
         var conIdAction = component.get("c.getContacts");
         conIdAction.setParams({
            "visitReportId": component.get("v.recordId")
        });
        
        conIdAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS") {
                component.set("v.contactId", response.getReturnValue());
            }
        });
         $A.enqueueAction(conIdAction);
    },
    
      saveRecord: function (component, event, helper) {
        var action = component.get("c.addContacts");
        action.setParams({
            "visitId": component.get("v.recordId"),
            "conId" :component.find("conlookupid").get("v.value"),
        });
        
        action.setCallback(this, function(response){
            var res=response.getReturnValue()
            if(res=="SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Success!",
                    "type": "Success",
                    "message": "Contacts have been added successfully!",
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
                    "message": "Please choose at least one Contact!",
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