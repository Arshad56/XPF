({
    handleClick : function(component, event, helper) {
        var record = component.get("v.simpleRecord");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Visit_Report_Item__c",
            "defaultFieldValues": {
                "Visit_Report_ID__c" :record.Visit_Report_ID__c,
                "Account_Name__c":record.Account_Name__c,
                "Key_Country_Discussed__c" : record.Key_Country_Discussed__c,
                "Key_City_Port_Discussed__c" : record.Key_City_Port_Discussed__c,
                "Discussed_Service__c" :record.Discussed_Service__c,
                "Agenda__c" : record.Agenda__c,
                "Feedback__c":record.Feedback__c,
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