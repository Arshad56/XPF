trigger CountUpdate on Visit_Report_Item__c (after insert,after update,after delete,after undelete) {
  set<ID> ParentID= new set<ID>();
      if(trigger.IsInsert)
         {
          for(Visit_Report_Item__c vo : trigger.new)
             ParentID.add(vo.Visit_Report_ID__c);
         }
      if(trigger.IsUpdate)
         {
          for(Visit_Report_Item__c vo : trigger.new)
             ParentID.add(vo.Visit_Report_ID__c);
         }
      if(trigger.isDelete)
         {
          for(Visit_Report_Item__c vo : trigger.old)
             ParentID.add(vo.Visit_Report_ID__c);
         }
      if(trigger.IsUndelete)
         {
          for(Visit_Report_Item__c vo : trigger.new)
             ParentID.add(vo.Visit_Report_ID__c);
         }
         
            if(ParentID.size() > 0 && ParentID != null)
                {
                system.debug('the parent id is-->' + ParentID);
                list<Visit_Report__c> FetchinngChildRecordSize = new list<Visit_Report__c>([select Total_Number_of_Visit_Report_Items__c,(select Name from Visit_Report_Items__r) from Visit_Report__c where id=:ParentID]);
                  for(Visit_Report__c ParentFields : FetchinngChildRecordSize)
                    {                     
                     system.debug('size of child objects-->'+ParentFields.Visit_Report_Items__r.size());
                     ParentFields.Total_Number_of_Visit_Report_Items__c=ParentFields.Visit_Report_Items__r.size();
                    }
                    update FetchinngChildRecordSize;
                }

}