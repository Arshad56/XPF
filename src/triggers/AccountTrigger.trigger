trigger AccountTrigger on Account (After update) {
    Set<Id> ownerIds = new Set<Id>();
    List<String> OwnerEmail = new List<String>();
    List<Messaging.SingleEmailMessage> emailToOwner = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    for (Account acc : Trigger.new){
        if(acc.OwnerId != trigger.oldMap.get(acc.Id).OwnerId)
            ownerIds.add(trigger.oldMap.get(acc.Id).OwnerId);
    }
    if(ownerIds.size()>0){
        for(User u : [select id,name,email FROM user 
                      WHERE id in:ownerIds])
            OwnerEmail.add(u.Email);
        EmailTemplate templateId = [Select id FROM EmailTemplate 
                                    WHERE name = 'Notification Old Account Owner' LIMIT 1];
        
        if(OwnerEmail.size()>0){
            for(Account acc : trigger.new){
                mail.setTemplateID(templateId.Id); 
                mail.setToAddresses(OwnerEmail);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(acc.OwnerId);
                emailToOwner.add(mail);
            }
        } 
        try{
            if(Label.send_Notification_to_Old_Owner == 'True')
                Messaging.sendEmail(emailToOwner);
        }
        catch(Exception e){
            system.debug('-------------exception------'+e); }
        
    }
}