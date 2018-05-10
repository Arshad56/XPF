({
	doInit: function(component, event, helper) {
		helper.init(component);
   },
   toggleFollowUpDate : function(component, event, helper) {
      var changeElement = component.find("followSect");
      $A.util.toggleClass(changeElement, "slds-hide");
      
  },
  saveExp : function(component, event, helper) {
	  		component.set("v.expWrapper.expItem.Currency_Code__c",component.get("v.currencyString"));
	       var args = event.getParam("arguments");
	       console.log(args.from);
	       component.set("v.from",args.from);
	       helper.saveDirect(component);
	       
   }, 
   handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    handleExpEvent: function(component, event, helper) {
    	console.log('--handleExpEvent--'+component.get("v.ExpId"));
    	component.set("v.ExpId",component.get("v.ExpId"));
    	component.set("v.showFileMsg",true);
    },
    
    done : function(component, event, helper) {
    	if(component.get("v.from") == "Save"){
    	     component.getEvent("initExpList").setParams({"from" : "showButtonsSave"  }).fire();
    	 }else{
    		 component.getEvent("initExpList").setParams({"from" : "showButtons"  }).fire();
    		 component.set("v.fileUpload",false);
    		 helper.init(component)
    	 }
    },
    assignCurrency: function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
    	component.set("v.expWrapper.expItem.Currency_Code__c",component.get("v.currencyString")); 
    },
    handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        alert("File "+uploadedFiles[0].name+" Uploaded successfully.");
    	
    }
})