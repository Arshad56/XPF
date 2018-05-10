trigger ContactTrigger on Contact (after update) {
    Set<Id> ownerIds = new Set<Id>();
    List<String> OwnerEmail = new List<String>();
    List<Messaging.SingleEmailMessage> msgToOwner = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    for (Contact con : Trigger.new){
        if(con.OwnerId != trigger.oldMap.get(con.Id).OwnerId)
            ownerIds.add(trigger.oldMap.get(con.Id).OwnerId);
    }
    if(ownerIds.size()>0){
        for(User u : [select id,name,email FROM user 
                      WHERE id in:ownerIds])
            OwnerEmail.add(u.Email);
        EmailTemplate templateId = [Select id FROM EmailTemplate 
                                    WHERE name = 'Notification Old Contact Owner' LIMIT 1];
        
        if(OwnerEmail.size()>0){
            for(Contact con : trigger.new){
                mail.setTemplateID(templateId.Id); 
                mail.setSaveAsActivity(false);
                mail.setToAddresses(OwnerEmail);
                mail.setTargetObjectId(con.id);
                msgToOwner.add(mail);
            }
        } 
        try{
            if(Label.send_Notification_to_Old_Owner == 'True')
            	Messaging.sendEmail(msgToOwner);
        }
        catch(Exception e){
            system.debug('-------------exception------'+e); }
        
    }
}