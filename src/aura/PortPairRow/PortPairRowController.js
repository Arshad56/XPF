({
    doInit : function(component,event,helper){
    	component.set("v.xpfString",component.get("v.portPair.Arragement__c")); 
    	component.set("v.currencyString",component.get("v.portPair.Currency_Code__c")); 
    	component.set("v.hideDelete",(component.get("v.portPair.Id") == null && component.get("v.rowIndex") == 0));
    },
    assignXPF: function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
    	component.set("v.portPair.Arragement__c",component.get("v.xpfString")); 
    	component.getEvent("sumRowPP").fire();
    },assignCurrency: function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
    	component.set("v.portPair.Currency_Code__c",component.get("v.currencyString")); 
    },removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
     component.set("v.portPair.Service__c","")
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    volRateChange : function(component, event, helper){
    	console.log('Arrangement-->'+component.get("v.portPair.Arragement__c"));
    	console.log('vol-->'+component.get("v.portPair.Volume_Teus__c"));
    	console.log('rate-->'+component.get("v.portPair.Req_Rate__c"));
    	component.getEvent("sumRowPP").fire();
    },
})