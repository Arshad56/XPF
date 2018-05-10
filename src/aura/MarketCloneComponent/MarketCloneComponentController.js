({
    handleClick : function(component, event, helper) {
        var record = component.get("v.simpleRecord");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Market_Intelligence__c",
            "defaultFieldValues": {
                "Type__c": record.Type__c,
                "Country_Discussed__c":record.Country_Discussed__c,
                "City_Port__c" : record.City_Port__c,
                "Visit_Report__c" : record.Visit_Report__c,
                "Account_Name__c" : record.Account_Name__c,
                "Deal_Name__c" :record.Deal_Name__c,
                "Remarks__c" : record.Remarks__c,
                "Parent_Id__c": component.get("v.recordId")
            }
        });
        createRecordEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    handleRecordUpdated: function(component, event, helper){
        //alert(component.find("v.forceRecordCmp"));
        
        
    },
    cancel: function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
    }
})