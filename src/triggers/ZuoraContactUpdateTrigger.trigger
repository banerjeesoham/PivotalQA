trigger ZuoraContactUpdateTrigger on Contact (after update) {
    list<Contact> con = new List<Contact>();
    for(Contact contactCheck:Trigger.new){
     System.debug('Inside zuora trigger--'+contactCheck.Zuora_Future__c);
     if(contactCheck.Zuora_Future__c ==False)
     con.add(contactCheck);
     System.debug('Inside zuora trigger--'+con);
    }
    if(!con.isEmpty()){
    if (Trigger.new.size() == 1) {
        Contact ctct = Trigger.new[0];
        System.debug('Inside zuora trigger');
        ZuoraCalloutHandler.updateZuoraContacts(String.valueOf(ctct.Id), ctct.MailingStreet, ctct.MailingCity, ctct.MailingCountryCode, ctct.MailingPostalCode, ctct.MailingStateCode, ctct.FirstName, ctct.LastName, ctct.Email, ctct.Phone);

        //List<Zuora__CustomerAccount__c> billToAccounts = [SELECT Id, Bill_To_Contact_Address__c FROM Zuora__CustomerAccount__c where CRM_Bill_To_Contact_Id__c = :ctct.Id];
        //List<Zuora__CustomerAccount__c> soldToAccounts = [SELECT Id, Sold_To_Contact_Address__c FROM Zuora__CustomerAccount__c where CRM_Sold_To_Contact_Id__c = :ctct.Id];
        //for (Zuora__CustomerAccount__c acct : billToAccounts) {
        //    acct.Bill_To_Contact_Address__c = ctct.MailingStreet+'\n '+ctct.MailingCity+', '+ctct.MailingStateCode+' '+ctct.MailingPostalCode+' '+ctct.MailingCountryCode;
        //}
        //update billToAccounts;
        //for (Zuora__CustomerAccount__c acct : soldToAccounts) {
        //    acct.Sold_To_Contact_Address__c = ctct.MailingStreet+'\n '+ctct.MailingCity+', '+ctct.MailingStateCode+' '+ctct.MailingPostalCode+' '+ctct.MailingCountryCode;
        //}
        //update soldToAccounts;
           } 
       }
   }