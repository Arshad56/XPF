({
	doInit : function(component, event, helper){
       component.set("v.AccessLevel",component.get("v.vrShare.vps.AccessLevel"));
    },removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    assignPicklist : function(component, event, helper){
       component.set("v.vrShare.vps.AccessLevel",component.get("v.AccessLevel"));
    }
})