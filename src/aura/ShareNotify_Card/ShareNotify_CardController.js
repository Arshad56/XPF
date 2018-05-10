({
	doInit : function(component, event, helper){
       component.set("v.AccessLevel",component.get("v.shareItem.accessLevel"));
    },removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    assignPicklist : function(component, event, helper){
       component.set("v.shareItem.accessLevel",component.get("v.AccessLevel"));
    }
})