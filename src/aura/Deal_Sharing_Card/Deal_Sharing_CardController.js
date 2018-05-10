({
	doInit : function(component, event, helper){
       component.set("v.AccessLevel",component.get("v.dealShare.dealShr.OpportunityAccessLevel"));
    },removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    assignPicklist : function(component, event, helper){
       component.set("v.dealShare.dealShr.OpportunityAccessLevel",component.get("v.AccessLevel"));
       console.log(component.get("v.dealShare"));
    }
})