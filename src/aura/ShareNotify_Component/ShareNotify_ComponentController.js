({
	doInit : function(component, event, helper) {
		helper.callInit(component);
	},
	handleActive: function(component, event, helper) {
		var source = event.getSource();
        if(source.get("v.id") == 'list'){
        	component.set("v.isListView",true);
        }else{
        	component.set("v.isListView",false);
        }
	},
	done: function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    },
    saveShr: function(component, event, helper) {
    	console.log('->'+component.find("shareBlock"));
		var childComponent = component.find("shareBlock");
    	childComponent.getSaveShare();
    	console.log('->2');
    	helper.saveRecord(component);
    	console.log('->3');
    },
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.shareList");
        var removedIds = component.get("v.removedIds");
        console.log(JSON.stringify(component.get("v.removedIds")));
        
        console.log('index-->'+index);
        console.log('AllRowsList[index]-->'+AllRowsList[index]);
        removedIds.push(AllRowsList[index].recId);
        
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.shareList", AllRowsList);
        component.set("v.removedIds", removedIds);
        
         console.log(JSON.stringify(component.get("v.removedIds")));
    } ,
})