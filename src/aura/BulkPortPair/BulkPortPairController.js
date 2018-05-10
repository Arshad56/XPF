({
    // function call on component Load
    doInit: function(component, event, helper) {
        var dealId  = component.get("v.recordId");
        console.log('dealId-->'+dealId);
        var action = component.get("c.getPortPairs");
        action.setParams({
            "dealId" : dealId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
            	var resp = JSON.parse(response.getReturnValue());
            	console.log('resp11-->'+JSON.stringify(resp));
            	if(resp.length > 0){
            		var ppList = JSON.parse( response.getReturnValue());
            		helper.sumRows(component,ppList);
            		component.set("v.portPairList", ppList);
            	}else{
            		helper.createObjectData(component, event, "2");
            	}
            	//component.getEvent("initiateSR").setParams().fire();
            }else if(state === "ERROR"){
            	var errors = action.getError();
            	console.log('errors-->'+errors[0].message);
            }
        });
        $A.enqueueAction(action);  
    },
    sumrizeRow: function(component, event, helper) {
    	var ppList = component.get("v.portPairList");
    	console.log('ppList-->'+ppList);
        helper.sumRows(component,ppList);
    },
    refreshList: function(component, event, helper) {
    	var allPP = component.get("v.portPairList");
        component.set("v.portPairList",allPP);
    },
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event, "1");
    },
    AddNewRowButton : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
       console.log("1Inside Helper"+ component.get("v.portPairList"));
        helper.createObjectData(component, event, "1"); 
    },
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        //if(index == '0')
        	//helper.createObjectData(component, event, "1");
        var AllRowsList = component.get("v.portPairList");
        console.log('AllRowsList1-->'+JSON.stringify(AllRowsList));
        AllRowsList.splice(index, 1);
        console.log('AllRowsList2-->'+JSON.stringify(AllRowsList));
        component.set("v.portPairList", AllRowsList);
        var ppList = component.get("v.portPairList");
        helper.sumRows(component,ppList);
    }
})