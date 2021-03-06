@isTest
Private class UpdateContactUserTC{
static Id cont;
@isTest
Private static void Test1(){
    Test.startTest();
        TestDataUtil.dataValueMapCSData(); 
        system.debug('recur--'+checkRecursive.checkUser+'--'+checkRecursive.checkContact);
       
        Contact con = TestDataUtil.createPortalContact();
       
        cont = con.Id;
        Test.stopTest();
        system.debug('recur--'+checkRecursive.checkUser+'--'+checkRecursive.checkContact);
        system.debug('User=='+con);
       
        User u1 = [Select Id,LanguageLocaleKey,TimeZoneSidKey,ContactId from User where ContactId =: cont];
        
        System.runAs(u1){
        u1.TimeZoneSidKey ='Pacific/Fiji';
        u1.LanguageLocaleKey ='zh_TW';
        
        checkRecursive.checkUser = true;
        checkRecursive.checkContact = false;
        update u1;
         
        }
  }
}