trigger TerminalTrigger on Terminal__c (before insert, before update) {
    
    Map<String,String> UniqueIdToCodeMap = new Map<String,String>();
    Set<String> portCodeExtIdSet = new Set<String>();
    
    if(trigger.isBefore && trigger.isInsert){
        for(Terminal__c ter : trigger.new)
            if(ter.Port_Code_External__c != NULL && ter.Port_Code__c==NULL)
            	portCodeExtIdSet.add(ter.Port_Code_External__c);
        
        if(portCodeExtIdSet.size() > 0){
            for(port__c port : [Select id, Port_Code_External_ID__c,Name 
                                From port__c 
                                WHERE Port_Code_External_ID__c IN :portCodeExtIdSet])
                
                UniqueIdToCodeMap.put(port.Port_Code_External_ID__c,port.Id); 
            
            for(Terminal__c ter : trigger.new) {
                if(UniqueIdToCodeMap.containsKey(ter.Port_Code_External__c))  {
                    ter.Port_Code__c = UniqueIdToCodeMap.get(ter.Port_Code_External__c);
                }
            }
        }
    } else if(trigger.isBefore && trigger.isUpdate){
        for(Terminal__c ter : Trigger.new){
             if((ter.Port_Code_External__c!=Trigger.oldMap.get(ter.id).Port_Code_External__c) && 
               ter.Port_Code_External__c != NULL && ter.Port_Code__c!=NULL)
            	portCodeExtIdSet.add(ter.Port_Code_External__c);
        }
        if(portCodeExtIdSet.size() > 0){
            for(port__c port : [Select id, Port_Code_External_ID__c,Name 
                                From port__c 
                                WHERE Port_Code_External_ID__c IN :portCodeExtIdSet])
                
                UniqueIdToCodeMap.put(port.Port_Code_External_ID__c,port.Id); 
            
            for(Terminal__c ter : trigger.new) 
                if(UniqueIdToCodeMap.containsKey(ter.Port_Code_External__c)) {
                ter.Port_Code__c = UniqueIdToCodeMap.get(ter.Port_Code_External__c);
                }
        }
    }
}