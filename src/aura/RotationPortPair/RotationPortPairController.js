({
 
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        //helper.createObjectData(component, event, "1");
        var dealId  = component.get("v.recordId");
        console.log('Service Rotation Start-->'+dealId);
        var action = component.get("c.getServiceRotations");
        action.setParams({
            "dealId" : dealId
        });
        console.log('Service Rotation Mid-->'+dealId);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Service Rotation state-->'+state);
            if (state === "SUCCESS") {
            	var resp = JSON.parse(response.getReturnValue());
            	console.log('resp22-->'+JSON.stringify(resp));
            	helper.sumRows(component,resp);
            	if(resp.length > 0){
            		component.set("v.rpWrapper", resp);
            	}else{
            		helper.createObjectData(component, event, "1");
            	}
            }else if(state === "ERROR"){
            	var errors = action.getError();
            	console.log('errors-->'+errors[0].message);
            }
        });
        
        $A.enqueueAction(action);
    },
    sumrizeRow: function(component, event, helper) {
    console.log('Summarize-- SR');
    	var svrList = component.get("v.rpWrapper");
        helper.sumRows(component,svrList);
    },
    initiateData: function(component, event, helper) {
    	event.stopPropagation();
        var dealId  = component.get("v.recordId");
        console.log('dealId-->'+dealId);
        var action = component.get("c.getServiceRotations");
        action.setParams({
            "dealId" : dealId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
            	var resp = response.getReturnValue();
            	console.log('resp22-->'+JSON.stringify(resp));
            	if(resp.length > 0){
            		component.set("v.rpWrapper", resp);
            	}else{
            		helper.createObjectData(component, event, "1");
            	}
            }else if(state === "ERROR"){
            	var errors = action.getError();
            	console.log('errors-->'+errors[0].message);
            }
        });
        $A.enqueueAction(action);
        
    },
 
    // function for create new object Row in Contact List 
    AddRDRowEvt: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        var index = event.getParam("indexVar");
        console.log('index--'+index);
        var AllRowsList = component.get("v.rpWrapper");
        console.log("AllRowsList->"+AllRowsList);
        var rdInst = AllRowsList[index];
        console.log("Added11 rdInst->"+rdInst);
        rdInst.listRD.push({
        	 'sobjectType': 'Service_Rotation_Detail__c',
        	 'Currency_Code__c':'USD'
        });
        AllRowsList[index] = rdInst;
        console.log("Added22 rdInst->"+rdInst);
        console.log("Added->"+AllRowsList);
        component.set("v.rpWrapper", AllRowsList);
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        //if(index == '0')
        //helper.createObjectData(component, event, "1");
        var AllRowsList = component.get("v.rpWrapper");
        AllRowsList.splice(index, 1);
        console.log('Remove--'+index);
        component.set("v.rpWrapper", AllRowsList);
        var ppList = component.get("v.portPairList");
        helper.sumRows(component,ppList);
    },
    AddNewRowButton : function(component, event, helper){
       console.log("1Inside Helper"+ component.get("v.rpWrapper"));
        helper.createObjectData(component, event, "1"); 
    },
})