({
	save: function(component, event, helper) {
		/*
		Call for Save is same for all tabs. they are differentiated based on boolean variables
		 */
		helper.callSave(component,"Save");
		if(!component.get("v.eiList"))
			component.set("v.editView",false);
	},
	saveNew: function(component, event, helper) {
		/*
		Call for Save&New is same for all tabs. they are differentiated based on boolean variables
		 */
		helper.callSave(component,"SaveNew");
	},
	handleActive: function(component, event, helper) {
		/*
		This action is to handle showing list view of selected tab
		 */
        var source = event.getSource();
        switch(source.get("v.id")) {
            case "VRD":
            	component.set("v.vrdList",true);
            	component.set("v.odList",false);
            	component.set("v.miList",false);
            	component.set("v.eiList",false);
                break;
            case "OD":
            	component.set("v.vrdList",false);
            	component.set("v.odList",true);
            	component.set("v.miList",false);
            	component.set("v.eiList",false);
                break;
            case "MI":
            	component.set("v.vrdList",false);
            	component.set("v.odList",false);
            	component.set("v.miList",true);
            	component.set("v.eiList",false);
                break;
            case "EI":
            	component.set("v.vrdList",false);
            	component.set("v.odList",false);
            	component.set("v.miList",false);
            	component.set("v.eiList",true);
                break;
        }
        component.set("v.editView",false);
    },
    addNew: function(component, event, helper) {
    	/*
		Call for Add new is same for all tabs. they are differentiated based on boolean variables by making editView true
		 */
    	var vrdList = component.get("v.vrdList");
    	var odList = component.get("v.odList");
    	var miList = component.get("v.miList");
    	var eiList = component.get("v.eiList");
    	console.log('vrdList->'+vrdList);
    	console.log('odList->'+odList);
    	console.log('miList->'+miList);
    	console.log('eiList->'+eiList);
    	
    		component.set("v.editView",true);
    },
    cancel: function(component, event, helper) {
		component.set("v.editView",false);
    },
    closeQuickAction: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
    },
    handleExpList: function(component, event, helper) {
    	/*
			for Expense Item we handle hide/show all buttons on VR_Interface through c:InitExp Event
		 */
    	var from = event.getParam("from");
    	 console.log('Init exp List');
    	if(from == 'Save'){
    		component.set("v.editView",false);
    	}else if(from =='hideButtons'){
    		component.set("v.hideButtons",true);
    	}else if(from =='showButtons'){
    		component.set("v.hideButtons",false);
    	}else if(from =='showButtonsSave'){
    		component.set("v.hideButtons",false);
    		component.set("v.editView",false);
    	}
    	 console.log('Init exp List');
		 console.log('get view--->'+component.get("v.editView"));
	}     
})