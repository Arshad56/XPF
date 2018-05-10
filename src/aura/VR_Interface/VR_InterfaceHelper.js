({
	callSave: function(component, action) {
		if(component.get("v.vrdList")){
			var childComponent = component.find("Visit_Report_Details");
        	 childComponent.getSaveVRI(action);
		}else if(component.get("v.odList")){
			var childComponent = component.find("Deal_Details");
        	childComponent.getSaveDeal(action);
		}else if(component.get("v.miList")){
			var childComponent = component.find("MI_Details");
        	childComponent.getSaveMI(action);
		}else if(component.get("v.eiList")){
			var childComponent = component.find("Exp_Details");
        	childComponent.getSaveExp(action);
		}
			$A.get('e.force:refreshView').fire();
	}
})