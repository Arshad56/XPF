({
	doInit : function(component, event, helper){
       component.set("v.AccessLevel",component.get("v.miShare.mis.AccessLevel"));
    },removeRow : function(component, event, helper){
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    assignPicklist : function(component, event, helper){
       component.set("v.miShare.mis.AccessLevel",component.get("v.AccessLevel"));
       console.log(component.get("v.miShare"));
    }
})