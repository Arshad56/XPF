({
   doInit: function(component, event, helper) {
      helper.fetchCountryAndCity(component);
      if(component.get("v.isAction")){
    	 
	         
    	  var countryAction = component.get("c.getCountry");
	         countryAction.setParams({
	            "recordId": component.get("v.recordId")
	        });
	        
	        countryAction.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS") {
	            	console.log('1--->'+JSON.stringify(response.getReturnValue()));
	                var cltrPill = component.get('v.selectedOptionPillsCntr'); 
	            	var resp = response.getReturnValue();
	            	
	            	var controllingList = component.get("v.controllingList");
	            	for (var indexVar = 0; indexVar < resp.length; indexVar++) {
            			for (var j = 0; j < controllingList.length; j++) {
		        			 if(controllingList[j] == resp[indexVar]){
		        				 controllingList.splice(j, 1);
		        			 }
		        		 }
		        		 cltrPill.push({"value":resp[indexVar],"label":resp[indexVar],"destroyable":"true"});
		        		 component.getEvent("onKeyCountryChange").setParams({"value" : resp[indexVar] }).fire();
	            	}
	            	controllingList.sort();
	            	component.set("v.controllingList",controllingList);
	                component.set("v.selectedOptionPillsCntr", cltrPill);
	            }
	        });
	         $A.enqueueAction(countryAction);
	         
	         var cityAction = component.get("c.getCity");
	         cityAction.setParams({
	            "recordId": component.get("v.recordId")
	        });
	        
	        cityAction.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS") {
	            	console.log('2--->'+JSON.stringify(response.getReturnValue()));
	            	var depPill = component.get('v.selectedOptionPillsDep'); 
	            	var resp = response.getReturnValue();
	            	var dependentList = component.get("v.dependentList");
	            	console.log('dep List-->'+component.get("v.dependentList"));
	            	for (var indexVar = 0; indexVar < resp.length; indexVar++) {
	            		for (var j = 0; j < dependentList.length; j++) {
		        			 if(dependentList[j] == resp[indexVar]){
		        				 dependentList.splice(j, 1);
		        			 }
		        		 }
	            		depPill.push({"value":resp[indexVar],"label":resp[indexVar],"destroyable":"true"});
	            	} 
	            	dependentList.sort();
	            	component.set("v.dependentList",dependentList);
	                component.set("v.selectedOptionPillsDep", depPill);
	                console.log('Comp end--->');
	            }
	        });
	         $A.enqueueAction(cityAction);
      }
   },
   /*
	* When Controlling piclist values are removed. dependent picklist values are removed from the list
	*
    */
   handleRemoveControllingEvent: function(component, event, helper) {
	   var country = event.getParam("value");
	   console.log('country-->'+country);
	   var action = component.get("c.getKeyCities");
	    action.setParams({
	    	'country': country
	    });
      
		action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            console.log('response-->'+response);
            
            if (state === "SUCCESS") {
            	/*
                * Add City to controlling list
                */
               console.log('country-->'+country);
               console.log('component.get(v.controllingList)-->'+component.get("v.controllingList"));
               var countries = component.get("v.controllingList");
               
               if( !(countries.indexOf(country) > -1) ) {
                    countries.push(country);
               }
               countries.sort();
               component.set("v.controllingList",countries);
               console.log('component.get(v.controllingList)-->'+component.get("v.controllingList"));
               /*
                */
                
            	var dependent = component.get("v.dependent");
            	var dependentList = component.get("v.dependentList");
            	var selectedOptionPillsDep = component.get("v.selectedOptionPillsDep");
            	
            	console.log('dependent11-->'+dependent);
            	console.log('dependentList11-->'+dependentList);
            	console.log('component.get("v.selectedOptionPillsDep")-->'+component.get("v.selectedOptionPillsDep"));
            	var listRemoveCity = response.getReturnValue();
            	
            	console.log('listRemoveCity-->'+listRemoveCity);
	        	 for (var i = 0; i < listRemoveCity.length; i++) {
	        		 console.log(i+ ' len '+listRemoveCity.length+' listRemoveCity[i]-->'+listRemoveCity[i]);
	        		 if(dependent != null){
	        			 dependent =  dependent.replace(';'+listRemoveCity[i],'');
	        			 dependent = dependent.replace(listRemoveCity[i],'');
	        		 }
	        		 
	        		 for (var j = 0; j < dependentList.length; j++) {
	        			 if(dependentList[j] == listRemoveCity[i]){
	        				 dependentList.splice(j, 1);
	        			 }
	        		 }
	        		 for (var k = 0; k < selectedOptionPillsDep.length; k++) {
	        			 console.log(i+ ' remove-->'+selectedOptionPillsDep[k].value );
	        			 if(selectedOptionPillsDep[k].value == listRemoveCity[i]){
	        				 selectedOptionPillsDep.splice(k, 1);
	        			 }
	        		 }
	        	  }
	        	  dependentList.sort();
	        	  component.set("v.dependent",dependent);
	        	  component.set("v.dependentList",dependentList);
	        	  component.set("v.selectedOptionPillsDep",selectedOptionPillsDep);
            }else if(state === "ERROR"){
            	alert('Error Occured!!');
            }
        });
        // enqueue the server side action  
        $A.enqueueAction(action);
        
   },
   
   /*
	* When Controlling piclist values are added. dependent picklist values are added in the list
	*
    */
	 handleSelectChangeEvent: function(component, event, helper) {
	    var country;
	    if(!component.get("v.isMultiSelect")){
	    	country = component.find("levels").get("v.value");
	    	console.log("1111country-->"+country);
	    	component.set("v.selectedOptionPillsDep",[]);
	    	component.set("v.dependent","");
	    	component.set("v.dependentList",[]);
	    }else{
	        country = event.getParam("value");
	    }
	    if(country){
	    	var cityList = component.get("v.dependentList");
		    var action = component.get("c.getKeyCities");
		    action.setParams({
		    	'country': country
		    });
			action.setCallback(this, function(response) {
	            var state = response.getState();
	            console.log(state);
	            console.log('response call-->'+response);
	            if (state === "SUCCESS") {
	            	var listCity = response.getReturnValue();
	            	if(!component.get("v.isMultiSelect")){
	            		cityList = [];
	            	}
	            	console.log('HS cityList-->'+cityList);
	            	var depList = component.get("v.selectedOptionPillsDep");
	            	var isTrue = false;
	            	 for (var i = 0; i < listCity.length; i++) {
	            		 if(component.get("v.isAction")){
	            			 isTrue = false;
	            			 for (var j = 0; j < depList.length; j++) {
			        			 if(depList[j].label == listCity[i]){
			        				isTrue = true; 
			        			 }
			        		 }
			        		 if(!isTrue){
			        			 cityList.push(listCity[i]);
			        		 }
	            		 }else{
	            			 cityList.push(listCity[i]);
	            		 }
	            	  }
	            	  cityList.sort();
				    component.set("v.dependentList", cityList);
				    console.log('HS cityList-->'+component.get("v.dependentList"));
	            }else if(state === "ERROR"){
	            	alert('Error Occured!!');
	            }
	        });
	        $A.enqueueAction(action);
	    }
	    
	},
   onControllerFieldChange: function(component, event, helper) {
      var listOpt = [];
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
//         component.find('conState').set("v.options", defaultVal);
         component.set("v.dependentList", listOpt);
          component.set("v.dependent", "");
         component.set("v.isDependentDisable", true);
         component.set("v.selectedOptionPillsCntr",[]);
         component.set("v.selectedOptionPillsDep",[]);
   },
 
   // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
      //alert(event.getSource().get("v.value"));
   },
   handleRemoveCityEvent: function(component, event, helper) {
       var city = event.getParam("value");
       console.log('city11-->'+city);
       console.log('component.get(v.dependentList)-->'+component.get("v.dependentList"));
       var cities = component.get("v.dependentList");
       
       if( !(cities.indexOf(city) > -1) ) {
            cities.push(city);
       }
       cities.sort();
       component.set("v.dependentList",cities);
       console.log('component.get(v.dependentList)-->'+component.get("v.dependentList"));
   }
})