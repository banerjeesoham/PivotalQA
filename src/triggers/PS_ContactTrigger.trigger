trigger PS_ContactTrigger on Contact (after insert,after update,before insert, before update) {

//system.debug('At start'+checkRecursive.runContactTrigger());
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
       List<Contact> lstCon = new List<Contact>();
        String managerId = DataValueMap__c.getInstance('PortalManagerProfileId').Data_Value__c;
        for(Contact c : Trigger.New){
            if(Trigger.isUpdate?c.Time_Zone__c != Trigger.oldMap.get(c.Id).Time_Zone__c:TRUE) {
            //if(Trigger.isUpdate && c.Time_Zone__c != Trigger.oldMap.get(c.Id).Time_Zone__c){
                lstCon.add(c);
            }
        }
        system.debug('inside trigger :'+UserInfo.getProfileId());
        if(Trigger.isInsert && UserInfo.getProfileId()==managerId){
          // Id cont = [Select Id,contactId from User where Id=: UserInfo.getUserId() limit 1].contactId;
           //Id acc =[Select AccountId from Contact where Id=: cont].accountId;
            Id acc= [Select Id,AccountId from User where Id=: UserInfo.getUserId() limit 1].accountId;
            system.debug('inside trigger :'+acc);
           for(Contact con:Trigger.new){
            con.AccountId =  acc;
           }
        }
        if(!lstCon.isEmpty()){
            PS_ContactTriggerHandler.populateBusinessHours(lstCon);
        }
    }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        if(checkRecursive.runContactTrigger()){
           PS_ContactTriggerHandler.createPortalUser();
           AccountHelper.UpdateCaseCommentOnContact(Trigger.New);
           System.debug('Trigger called : '+Trigger.isUpdate);
           if(Trigger.isUpdate){
           Map<Id,Contact> contactMap = new Map<Id,Contact>();
               for(Contact con : Trigger.new){
                   if(con.BusinessHours__c != Trigger.oldMap.get(con.Id).BusinessHours__c){
                          contactMap.put(con.Id,con);                
                   }         
               }
               if(!contactMap.isEmpty()){
                   PS_ContactTriggerHandler.updateAssociatedCases(contactMap);
               }
           }
        }
    }
    
}