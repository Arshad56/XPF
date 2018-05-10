({
	 doInit: function(component, event, helper) {
      helper.init(component);
	 },
	 toggleFollowUpDate : function(component, event, helper) {
	      var changeElement = component.find("followSect");
	      $A.util.toggleClass(changeElement, "slds-hide");
	 }
	 ,
  	  saveVRI : function(component, event, helper) {
	       var args = event.getParam("arguments");
          console.log('args>>>>>>>'+args.from);
          //if(helper.validateFields(component)){
        	  //alert('Saved!!');
        	  helper.saveRecord(component,args.from);
         // }
	       
  	  }
})