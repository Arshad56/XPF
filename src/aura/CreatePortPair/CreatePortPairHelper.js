({
    validateRequiredPP: function(component, event) {
        var isValid = true;
        var allPortRows = component.get("v.portPairList");
        
        for (var indexVar = 0; indexVar < allPortRows.length; indexVar++) {
        	if(allPortRows[indexVar].Volume_Teus__c > 0){
        		if(!this.validateLookup(allPortRows[indexVar].Service__c +'') &&  (!this.validateLookup(allPortRows[indexVar].Port_of_Loading__c +'') || !this.validateLookup(allPortRows[indexVar].Port_of_Discharge__c +''))){
	        		isValid = false;
	        		alert('Please enter Service or POL and POD in Port Pairs  ');//+ (indexVar + 1) );
	        		break;
	        	}else{
	        		isValid = true;
	        	}	
        	}else if (!(allPortRows[indexVar].Volume_Teus__c > 0)   &&  
              (allPortRows[indexVar].Rv__c ||
              this.validateLookup(allPortRows[indexVar].Port_of_Loading__c +'') || 
              this.validateLookup(allPortRows[indexVar].Terminal_of_Loading__c +'') || 
              this.validateLookup(allPortRows[indexVar].Port_of_Discharge__c +'') || 
              this.validateLookup(allPortRows[indexVar].Terminal_of_Discharge__c +'') || 
              this.validateLookup(allPortRows[indexVar].Service__c +'') ||
              allPortRows[indexVar].Weight__c > 0 ||
              allPortRows[indexVar].Req_Rate__c >0 || 
              allPortRows[indexVar].Remarks__c)){ 
                isValid = false;
                alert('Volume can\'t be blank in Port Pairs ');//+ (indexVar + 1) );
                break;
        	}
        }
        return isValid;
    },
    validateRequiredRP: function(component, event) {
       var isValid = true;
        var allRotaionRows = component.get("v.wrapperList");
        
        for (var indexVar = 0; indexVar < allRotaionRows.length; indexVar++) {
        var isRPEmpty = true;
        
        console.log('1-->'+!this.validateLookup(allRotaionRows[indexVar].rpRec.Service__c +''));
        		console.log(allRotaionRows[indexVar].rpRec.Volume_Teus__c + '2-->'+(allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0));
        		console.log('3-->'+(allRotaionRows[indexVar].Req_Rate__c > 0));
        		console.log('4-->'+(allRotaionRows[indexVar].rpRec.Weight__c > 0));
        		console.log('5-->'+(allRotaionRows[indexVar].rpRec.Remarks__c));
        	if( !(allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0) &&  
                (this.validateLookup(allRotaionRows[indexVar].rpRec.Service__c +'') ||
                allRotaionRows[indexVar].rpRec.Req_Rate__c >0 ||
                allRotaionRows[indexVar].Weight__c > 0 || 
                !(undefined == allRotaionRows[indexVar].rpRec.Remarks__c))){
        		isValid = false;
        		
        		alert('VOLUME can\'t be blank in Service Rotaion Pairs ');//+ (indexVar + 1) );
        		break;
        	}else if( allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0){
        		if(!this.validateRequiredRD(allRotaionRows[indexVar].listRD, indexVar+1)){
        			isValid = false;
        			break;
        		}
        	}else if( !(allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0)){
        		if(!this.validateRequiredRD11(allRotaionRows[indexVar].listRD, indexVar+1)){
        			isValid = false;
        			break;
        		}
        	}
        	
        }
        return isValid;
    },
    validateRequiredRD11: function(RDlist, indexVar) {
        var isValid = true;
        
        for(var inner = 0; inner < RDlist.length; inner++){
    		if(this.validateLookup(RDlist[inner].Port__c +'') ||
    		this.validateLookup(RDlist[inner].Terminal__c +'') ||
    		RDlist[inner].Remarks__c){
    			isValid = false;
    			alert('VOLUME can\'t be blank in Service Rotaion Pairs  ');//on row '+ (inner + 1)+ ' of Service Rotaion Pairs '+indexVar );
    			break;
    		}
    	}
    	
        return isValid;
    },validateRequiredRD: function(RDlist, indexVar) {
        var isValid = true;
        
        for(var inner = 0; inner < RDlist.length; inner++){
    		if(!this.validateLookup(RDlist[inner].Port__c +'') &&
    		(this.validateLookup(RDlist[inner].Terminal__c +'') ||
    		RDlist[inner].Remarks__c)){
    			isValid = false;
    			alert('PORT can\'t be blank in Rotaion Details ');//on row '+ (inner + 1)+ ' of Service Rotaion Pairs '+indexVar );
    			break;
    		}
    	}
    	
        return isValid;
    },
    validatePortPairEmpty: function(component, event) {
        var inValid = true;
        var allPortRows = component.get("v.portPairList");
        
        for (var indexVar = 0; indexVar < allPortRows.length; indexVar++) {
         console.log(indexVar+'-- Blank-->'+ allPortRows[indexVar].Rv__c)
           if (this.validateLookup(allPortRows[indexVar].Service__c +'') || 
              allPortRows[indexVar].Rv__c ||
              this.validateLookup(allPortRows[indexVar].Port_of_Loading__c +'')    || 
              this.validateLookup(allPortRows[indexVar].Terminal_of_Loading__c +'') || 
              this.validateLookup(allPortRows[indexVar].Port_of_Discharge__c +'') || 
              this.validateLookup(allPortRows[indexVar].Terminal_of_Discharge__c +'') || 
              allPortRows[indexVar].Weight__c > 0 ||  
              allPortRows[indexVar].Volume_Teus__c > 0 ||  
              allPortRows[indexVar].Req_Rate__c >0 || 
              allPortRows[indexVar].Remarks__c){ 
        		inValid = false;
    			break;
        	}
        }
        return inValid;
    },
    validateRRDRPEmpty: function(component, event) {
        var inValid = false;
        var allRotaionRows = component.get("v.wrapperList");
        for (var indexVar = 0; indexVar < allRotaionRows.length; indexVar++) {
    		if((!this.validateLookup(allRotaionRows[indexVar].rpRec.Service__c +'') &&
    		   !(allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0) )&&
    		   this.validateRotaionDetailEmpty(allRotaionRows[indexVar].listRD)){
    		   var inValid = true;
    		   console.log('1-->'+(allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0));
    		   console.log(allRotaionRows[indexVar].rpRec.Service__c+' 22-->'+this.validateLookup(allRotaionRows[indexVar].rpRec.Service__c +''));
    		   alert('Please select SERVICE or VOLUME in Service Rotation '+(indexVar+1));
    		   break; 
    		}
        }
        return inValid;
    },
    validateRotaionDetailEmpty: function(RDlist) {
        var inValid = false;
        console.log(inValid);
        for(var inner = 0; inner < RDlist.length; inner++){
    		if(this.validateLookup(RDlist[inner].Port__c +'') ||
    		this.validateLookup(RDlist[inner].Terminal__c +'') ||
    		RDlist[inner].Remarks__c
    		){
    			inValid = true;
    			break;
    		}
    	}
    	console.log('inValid-->'+inValid);
        return inValid;
    },
    validateRotaionPairEmpty: function(component, event) {
        var inValid = true;
        var allRotaionRows = component.get("v.wrapperList");
        
        for (var indexVar = 0; indexVar < allRotaionRows.length; indexVar++) {
        var isRPEmpty = true;
        	if(this.validateLookup(allRotaionRows[indexVar].rpRec.Service__c +'') ||
        	    allRotaionRows[indexVar].rpRec.Weight__c > 0 ||  
        		allRotaionRows[indexVar].rpRec.Volume_Teus__c > 0 ||  
                allRotaionRows[indexVar].rpRec.Req_Rate__c >0 || 
                allRotaionRows[indexVar].rpRec.Remarks__c){
                
        		inValid = false;
        		break;
        	}
        }
        return inValid;
    },
    validateLookup: function(lookup) {
    	//console.log(lookup.length +'--lookup--'+lookup );
    	
    	if(undefined ==lookup || lookup == null){
    		return false; 
    	}else if(lookup.length < 15){
    		return false;
    	}
    	return true;
    },
    sumRows: function(component) {
    	var ppList = component.get("v.portPairList");
    	var svrList = component.get("v.wrapperList");
    	var totalGive = 0;
		var totalTake = 0;
		for(var i = 0; i < ppList.length; i++){
    		if(ppList[i].Volume_Teus__c != null && ppList[i].Volume_Teus__c > 0 
    		  && ppList[i].Req_Rate__c != null && ppList[i].Req_Rate__c > 0)
    			if(ppList[i].Arragement__c == 'XPF to Customer' || ppList[i].Arragement__c == null){
    				totalGive += ppList[i].Volume_Teus__c * ppList[i].Req_Rate__c;
    			}else if(ppList[i].Arragement__c == 'Customer to XPF'){
    				totalTake += ppList[i].Volume_Teus__c * ppList[i].Req_Rate__c;
    			}
    	}
		for(var i = 0; i < svrList.length; i++){
    		if(svrList[i].rpRec.Volume_Teus__c != null && svrList[i].rpRec.Volume_Teus__c > 0 
    		  && svrList[i].rpRec.Req_Rate__c != null && svrList[i].rpRec.Req_Rate__c > 0)
    			if(svrList[i].rpRec.Arrangement__c == 'XPF to Customer' || svrList[i].rpRec.Arrangement__c == null){
    				totalGive += svrList[i].rpRec.Volume_Teus__c * svrList[i].rpRec.Req_Rate__c;
    			}else if(svrList[i].rpRec.Arrangement__c == 'Customer to XPF'){
    				totalTake += svrList[i].rpRec.Volume_Teus__c * svrList[i].rpRec.Req_Rate__c;
    			}
    	}
    	component.set("v.grandTotalGive", totalGive);
    	component.set("v.grandTotalTake", totalTake);
    	
    }
})