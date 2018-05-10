({	
	doInit : function(component,event,helper){
    	component.set("v.xpfString",component.get("v.RPInstance.rpRec.Arrangement__c")); 
    	component.set("v.currencyString",component.get("v.RPInstance.rpRec.Currency_Code__c")); 
    	component.set("v.hideDelete",(component.get("v.RPInstance.rpRec.Id") == null && component.get("v.rowIndex") == 0));
    },
    assignXPF: function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
    	component.set("v.RPInstance.rpRec.Arrangement__c",component.get("v.xpfString")); 
    	component.getEvent("sumRowSR").fire();
    },
    assignCurrency: function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
    	component.set("v.RPInstance.rpRec.Currency_Code__c",component.get("v.currencyString")); 
    },AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRPRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
     console.log('delete rowIndex--'+component.get("v.rowIndex"));
       component.getEvent("DeleteRPRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    volRateChange : function(component, event, helper){
    console.log('Summarize-- RP Item');
    	component.getEvent("sumRowSR").fire();
    },
  
})