({
   
    doInit: function(component, event, helper) {
    	component.set("v.RDInstance.Port__c",component.get("v.RDInstance.Port__c"));
    	component.set("v.hideDelete",(component.get("v.RDInstance.Id") == null && component.get("v.rowIndex") == 0));
    },
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRDRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
   
})