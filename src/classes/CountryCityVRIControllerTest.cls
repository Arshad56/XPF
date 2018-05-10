@isTest
public class CountryCityVRIControllerTest {

    static testMethod void testVRI(){
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Visit_Report_Item__c vri = new Visit_Report_Item__c();
        vri.Account_Name__c = acc.id;
        vri.Key_City_Port_Discussed__c = 'Delhi';
        vri.Key_Country_Discussed__c = 'India';
        insert vri;
        
        CountryCityVRIController.showErroMsg(vri.id);
        CountryCityVRIController.saveCountryCity(vri.id, vri.Key_Country_Discussed__c, vri.Key_City_Port_Discussed__c);
        CountryCityVRIController.getCity(vri.id);
        CountryCityVRIController.getCountryCity(vri.id);
        CountryCityVRIController.getCountry(vri.id);
    }
}