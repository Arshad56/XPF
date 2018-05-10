({
	doInit: function(component, event, helper) {
		
		helper.init(component);
   },
   toggleFollowUpDate : function(component, event, helper) {
      var changeElement = component.find("followSect");
      $A.util.toggleClass(changeElement, "slds-hide");
      
  },
  saveDeal : function(component, event, helper) {
	       var args = event.getParam("arguments");
	       console.log(args.from);
	       helper.saveRecord(component,args.from);
   },
})