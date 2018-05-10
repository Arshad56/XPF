public with sharing class RedirectToVP_Controller {
	public String keyPrefix{get;set;}
    public RedirectToVP_Controller(ApexPages.StandardController stdController){
    	Schema.DescribeSObjectResult vr = Visit_Report__c.sObjectType.getDescribe();
        keyPrefix = vr.getKeyPrefix();
    }
}