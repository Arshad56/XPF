({
	doInit : function(component) {
		let evt = $A.get("e.force:navigateToComponent");
		evt.setParams({
			componentDef : "ltngsharing:LightningSharing",
			componentAttributes: {
					recordId : component.get("v.recordId")
			}
		});
		evt.fire();
	}
})