({
	fetchCountryAndCity: function(component) {
		var action = component.get("c.getKeyCountries");
		action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log('response-->'+response);
            if (state === "SUCCESS") {
			    component.set("v.controllingList", response.getReturnValue());
            }else if(state === "ERROR"){
            	alert('Error Occured!!');
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
	},
   fetchPicklistValues: function(component, controllerField, dependentField) {
      // call the server side function  
      var action = component.get("c.getDependentOptionsImpl");
      // pass paramerters [object name , contrller field name ,dependent field name] -
      // to server side function 
 
      action.setParams({
         'objApiName': component.get("v.objInfo"),
         'contrfieldApiName': controllerField,
         'depfieldApiName': dependentField
      });
      //set callback   
      action.setCallback(this, function(response) {
         if (response.getState() == "SUCCESS") {
            //store the return response from server (map<string,List<string>>)  
            var StoreResponse = response.getReturnValue();
 
            // once set #StoreResponse to depnedentFieldMap attribute 
            component.set("v.depnedentFieldMap", StoreResponse);
 
            // create a empty array for store map keys(@@--->which is controller picklist values) 
 
            var listOfkeys = []; // for store all map keys (controller picklist values)
            var ControllerField = []; // for store controller picklist value to set on ui field. 
 
            // play a for loop on Return map 
            // and fill the all map key on listOfkeys variable.
            for (var singlekey in StoreResponse) {
               listOfkeys.push(singlekey);
            }
 
            //set the controller field value for ui:inputSelect  
            if (listOfkeys != undefined && listOfkeys.length > 0) {
               ControllerField.push({
                  class: "optionClass",
                  label: "--- None ---",
                  value: "--- None ---"
               });
            }
 
            for (var i = 0; i < listOfkeys.length; i++) {
               ControllerField.push({
                  class: "optionClass",
                  label: listOfkeys[i],
                  value: listOfkeys[i]
               });
            }
            // set the ControllerField variable values to country(controller picklist field)
            component.find('conCountry').set("v.options", ControllerField);
         }
      });
      $A.enqueueAction(action);
   },
 
 
   fetchDepValues: function(component, ListOfDependentFields) {
      // create a empty array var for store dependent picklist values for controller field)  
      var dependentFields = [];
 
      if (ListOfDependentFields != undefined && ListOfDependentFields.length > 0) {
         dependentFields.push({
            class: "optionClass",
            label: "--- None ---",
            value: "--- None ---"
         });
 
      }
      var listOpt = [];
      if(ListOfDependentFields != null)
      for (var i = 0; i < ListOfDependentFields.length; i++) {
         dependentFields.push({
            class: "optionClass",
            label: ListOfDependentFields[i],
            value: ListOfDependentFields[i]
         });
         listOpt.push(ListOfDependentFields[i]);
      }
      // set the dependentFields variable values to State(dependent picklist field) on ui:inputselect    
//      component.find('conState').set("v.options", dependentFields);
      console.log('listOpt-->'+listOpt);
      console.log('list-->'+component.get("v.dependentList"));
      // make disable false for ui:inputselect field 
       component.set("v.dependentList", listOpt);
       //component.set("v.selectedOptionPills",[]);
       component.set("v.dependent", "");
      component.set("v.isDependentDisable", false);
   },
})