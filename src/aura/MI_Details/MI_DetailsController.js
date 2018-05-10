({
	doInit: function(component, event, helper) {
		helper.init(component);
   },
   toggleFollowUpDate : function(component, event, helper) {
      var changeElement = component.find("followSect");
      $A.util.toggleClass(changeElement, "slds-hide");
      
  },
  saveMI : function(component, event, helper) {
	   component.set("v.miWrapper.miItem.Country_Discussed__c", component.get("v.country"));
	   component.set("v.miWrapper.miItem.City_Port_Discussed__c", component.get("v.city"));
       var args = event.getParam("arguments");
       console.log(args.from);
       helper.saveRecord(component,args.from);
   },
})