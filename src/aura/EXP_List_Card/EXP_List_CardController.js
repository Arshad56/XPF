({
	redirect : function(component, event, helper) {
		if($A.get('$Browser.formFactor') === 'DESKTOP'){
			window.open('/' + component.get('v.expItem.Id'));  
		}else{
			var navEvt = $A.get("e.force:navigateToSObject");
		    navEvt.setParams({
		      "recordId": component.get('v.expItem.Id'),
		      "slideDevName": "detail"
		    });
		    navEvt.fire();
		}
		
	}
})