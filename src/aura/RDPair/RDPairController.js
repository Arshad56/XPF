({
	doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        console.log('doInit of RD pair');
        helper.createObjectData(component, event, "1");
    },
 
    // function for create new object Row in Contact List 
    AddNewRDRowButton: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        component.getEvent("AddRDRowEvt").setParams({"indexVar" : component.get("v.parentRPIndex") }).fire();
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        if(index == '0')
        	helper.createObjectData(component, event, "1");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.rdList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        console.log('Remove--');
        component.set("v.rdList", AllRowsList);
    },
})