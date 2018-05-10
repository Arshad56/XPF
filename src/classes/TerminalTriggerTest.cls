@istest
public class TerminalTriggerTest {
    public static testmethod void mytest(){
        
        Port__c port = new Port__c();
        port.Name='testport';
        port.Port_Code_External_ID__c='dummy';
        
        Terminal__c terminal = new Terminal__c();
        terminal.Name='test terminal';
        terminal.Port_Code_External__c='dummy';
        test.startTest();
        insert port;
        try{
            insert terminal;
            terminal.Port_Code_External__c='dummy1';
            update terminal;
        }catch(DMLException e){}
        test.stopTest();
    }
    
}