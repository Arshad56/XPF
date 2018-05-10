({
	doInit : function(component, event, helper){
       component.set("v.AccessLevel",component.get("v.expShare.eis.AccessLevel"));
    },removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    assignPicklist : function(component, event, helper){
       component.set("v.expShare.eis.AccessLevel",component.get("v.AccessLevel"));
       console.log(component.get("v.expShare"));
    }
})