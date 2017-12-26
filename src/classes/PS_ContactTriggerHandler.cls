/*******************************************************************************************************************
* Apex Class Name  : PS_ContactTriggerHandler
* Test Class Name  : PS_ContactTriggerHandler_TC
* Version          : 1.0
* Created Date     : 26 July 2017
* Function         : class is used to Update the Profile based on the Customer Admin and Enable Portal User     Fields Present in contact detail Page. 
                     IF the Customer Admin Field will be True then Profile will be Customer Community Plus Login Manager and 
                     If Enable Portal User Field will be True then Profile will be Customer Community Plus Login User
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Hemavathi 
  Amit Kumar               7/26/2017                  intial version
  Deepa Lakamanhalli       11/09/2017               Auto Populate business hours based on time zone selected on Contact
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/

Public Class PS_ContactTriggerHandler{
    //Custom Setting Values 
    static String managerId = DataValueMap__c.getInstance('PortalManagerProfileId').Data_Value__c;
    static String userId = DataValueMap__c.getInstance('PortalUserProfileId').Data_Value__c;
    static List<PortalUserCreationMap__c > cSRecordsList =PortalUserCreationMap__c.getAll().Values();
    
    public static void createPortalUser(){
        Map<Id,Id> contactAccountIds = new Map<Id,Id>();
        Map<Id,Contact> contactsMap = new Map<Id,Contact>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        Map<Id,user> userMap = new Map<Id,user>();
        Set<Id> contactId = new Set<Id>();
        String contactIds ;
        String contactViewAllIds ;
        if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            for(contact con: (List<Contact>)Trigger.New){
                if(Trigger.isInsert){
                    contactMap.put(con.Id,con);
                }else{
                    Contact oldContact = (Contact) Trigger.OldMap.get(con.Id);
                    for(PortalUserCreationMap__c cSFields : cSRecordsList)
                    {
                        if(con.Customer_Admin__c != oldContact.Customer_Admin__c || con.get(cSFields.Source__c) != oldContact.get(cSFields.Source__c)){
                            contactMap.put(con.Id,con);
                        } 
                        if(con.Customer_Admin__c != oldContact.Customer_Admin__c){
                            contactIds = contactIds +','+con.Id;
                        }
                    }
                    contactId.add(con.Id);
                    if(con.View_Account_Cases__c != oldContact.View_Account_Cases__c){
                        contactViewAllIds = contactViewAllIds +','+con.Id;
                    }
                }
            }
            
            if(Trigger.isUpdate){
                Set<Id> updatePortalUserContact = new Set<Id>();
                for(User usr : [SELECT Id, ContactId , contact.AccountId,AccountId,contact.View_Account_Cases__c,ProfileId FROM user WHERE contactId =:contactId]){
                    if(contactMap.containsKey(usr.ContactId)){
                        updatePortalUserContact.add(usr.ContactId); 
                        if(contactIds!= null && contactIds.contains(usr.ContactId)){
                            usr.ProfileId = (contactMap.get(usr.ContactId).Customer_Admin__c?managerId:userId);
                            userMap.put(usr.Id,usr);
                        }
                        contactMap.remove(usr.ContactId);
                    }
                    if(contactViewAllIds != null && contactViewAllIds.contains(usr.ContactId)){
                        userMap.put(usr.Id,usr);
                    }
                }
                 if(updatePortalUserContact.size() > 0){
                    PS_ContactTriggerHandler.updatePortalUserRecord(updatePortalUserContact);
                }
                if(!userMap.isEmpty() && contactViewAllIds != null){
                    PS_ContactTriggerHandler.accountShareAccess(userMap,contactViewAllIds, true);
                }
                if(!userMap.isEmpty() && contactIds != null){
                    PS_ContactTriggerHandler.accountShareAccess(userMap,contactIds,false);
                }
            }
            //Insert new user record
            if(!contactMap.isEmpty()){
                List<User> userToInsert = new List<User>();
                for(Contact cont :contactMap.Values()){
                    User usrRecord = newPortalUserFormat(cont);
                    userToInsert.add(usrRecord);
                }
                if(userToInsert.size()>0){
                    try{
                        checkRecursive.checkUser = false;
                        Insert userToInsert;
                    }catch(Exception e){
                      ErrorLog.CreateER(e);//Exception captured in Utility Class Errorlog
                   }
                }
            }
        }
    }//End of Method
    /* Create Portal User */
    public static user newPortalUserFormat(Contact contObj){
        User usrRecord = new User();  
        //Get all fields from Custom Settings.
        for(PortalUserCreationMap__c cSFields : cSRecordsList)
        {
            usrRecord.put(cSFields.Name,contObj.get(cSFields.Source__c));
        }
        usrRecord.EmailEncodingKey = 'ISO-8859-1';
        String keyToNickName = contObj.LastName+contObj.Email+contObj.FirstName;
        String Nickname = generateRandomString(12,keyToNickName);
        usrRecord.Alias = generateRandomString(6,Nickname);
        usrRecord.CommunityNickname = Nickname;
        usrRecord.ProfileId = (contObj.Customer_Admin__c?managerId:userId);
        return usrRecord;
    }
    /* Update Portal User */
    @future
    public static void updatePortalUserRecord(Set<Id> contactRecIds){
        Map<Id,User> userToUpdate = new Map<Id,User>();
        Set<Id> userIds = new Set<Id>();
        String query = 'SELECT Customer_Admin__c , Language__c';
        //Get all fields from Custom Settings.
        for(PortalUserCreationMap__c cSFields : cSRecordsList)
        {
            if(!query.containsIgnoreCase(cSFields.Source__c)){
                query= query+' , '+cSFields.Source__c;
            }
        }
        query = query + ' FROM Contact WHERE id=: contactRecIds';
        Map<Id, sObject> contactMap = new Map<Id,sObject>();
        contactMap.putAll(Database.query(query));
        for(User usr : [SELECT Id, isActive ,ProfileId,ContactId,AccountId FROM User WHERE ContactId =:contactRecIds]){
            if(contactMap.containsKey(usr.ContactId)){
                Contact cont = (contact)contactMap.get(usr.ContactId);
                
                for(PortalUserCreationMap__c cSFields : cSRecordsList)
                {   
                    String byPass = 'ContactId,UserName';
                    if(!byPass.containsIgnoreCase(cSFields.Name)){
                        usr.put(cSFields.Name,cont.get(cSFields.Source__c));
                    }
                    
                }
                usr.ProfileId = (cont.Customer_Admin__c ? managerId : userId);
                userToUpdate.put(usr.Id,usr);
                
            }
        }
        if(!userToUpdate.isEmpty()){
            try{
                checkRecursive.checkUser = false;
                update userToUpdate.values();
            }catch(Exception e){
                ErrorLog.CreateER(e);//Exception captured in Utility Class Errorlog
            }
        }
    }
    /*To Update Accountshare to give access for user to Contact, Cases*/
    public static void accountShareAccess(Map<Id,user> userMap, String contactIds , Boolean isViewAll){
        List<AccountShare> accShareToUpdate = new List<AccountShare>();
        Map<AccountShare , Sobject> accShareSobject = new Map<AccountShare,SObject>();
        Map<Id,AccountContactRole> contactWithACRMap = new Map<Id,AccountContactRole>();
        List<AccountShare> accShareLst = new List<AccountShare>();
        if(!userMap.isEmpty()){
            accShareLst = [SELECT AccountAccessLevel,ContactAccessLevel,CaseAccessLevel, AccountId , userorGroupId FROM AccountShare WHERE UserorGroupId =: userMap.KeySet()];
        }
        if(!userMap.isEmpty() && !accShareLst.isEmpty()){
            if(isViewAll){
                for(AccountShare accShare : accShareLst){
                    User usr = userMap.get(accShare.userorGroupId);
                    if(usr.AccountId == accShare.AccountId){
                        accShare.caseAccessLevel = 'Read';
                        accShare.AccountAccessLevel = 'Read';                           
                        if(!usr.contact.View_Account_Cases__c){
                            accShare.caseAccessLevel = 'None';
                            accShare.contactAccessLevel = 'None';
                        }
                        accShareToUpdate.add(accShare);
                        accShareSobject.put(accShare,usr);
                    }
                }
            }
            if(!isViewAll && contactIds != null){
                String[] contactIdLst = contactIds.split(',');
                Map<String,PortalObjectAccess__c> portalObjectAccessMap = PortalObjectAccess__c.getAll();
                Map<Id,AccountContactRole> accountContactRoleMap = new Map<Id,AccountContactRole>([Select Id, Role, ContactId , AccountId from AccountContactRole where contactId =: contactIdLst]);
                
                if(!accountContactRoleMap.isEmpty()){
                    for(AccountContactRole acR : accountContactRoleMap.values()){
                        contactWithACRMap.put(acR.AccountId,acR);
                    }
                    for(AccountShare accShare : accShareLst){
                        user usr = userMap.get(accShare.UserorGroupId);
                        if(usr.AccountId != accShare.AccountId && contactWithACRMap.containsKey(accShare.AccountId)){
                            String role = String.valueOf(contactWithACRMap.get(accShare.AccountId).Role).remove('-');
                            String key = usr.ProfileId + role.deleteWhitespace();
                            PortalObjectAccess__c objAccess = portalObjectAccessMap.get(key);
                            String shareKey = accShare.AccountAccessLevel+accShare.ContactAccessLevel+accShare.CaseAccessLevel;
                            String masterKey = objAccess.Account__c+objAccess.Contact__c+objAccess.Case__c;
                            if(shareKey != masterKey){
                                accShare.AccountAccessLevel = objAccess.Account__c;
                                accShare.ContactAccessLevel = objAccess.Contact__c;
                                accShare.CaseAccessLevel = objAccess.Case__c;
                                accShareToUpdate.add(accShare);
                                accShareSobject.put(accShare,contactWithACRMap.get(accShare.AccountId));
                            }
                        }
                    }   
                }
            }
            if(!accShareToUpdate.isEmpty()){
                Database.SaveResult[] srList = Database.update(accShareToUpdate, false);
            }
        }
    }
    
    public static void updateAssociatedCases(Map<Id,Contact> contactMap){
        Map<Id,Case> caseMap = new Map<Id,Case>();
        list<case> caseToUpdate = new list<case>();
        for(Case caseObj : [Select Id, ContactId,Contact.BusinessHours__c, BusinessHoursId from case where contactId =: contactMap.KeySet() and Status != 'Closed']){
            if(contactMap.containsKey(caseObj.ContactId)){
                Contact con = contactMap.get(caseObj.ContactId);
                if(con.BusinessHours__c != null){
                    caseObj.BusinessHoursId = con.BusinessHours__c;
                    caseToUpdate.add(caseObj);
                }
            }
        }
        if(!caseToUpdate.isEmpty()){
            try{
                update caseToUpdate;
            }catch(Exception e){
               ErrorLog.CreateER(e);//Exception captured in Utility Class Errorlog
            }
        }
    }
    
    public static String generateRandomString(Integer len ,String key) {
        final String chars = key.trim()+'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    /*
    Start : Auto Populate business hours based on time zone selected on Contact
    */
    public static void populateBusinessHours(List<Contact> lstCon){
        Set<String> setConTimeZone = new Set<String>();
        for(Contact c : lstCon){
            if(c.Time_Zone__c!=NULL){
                setConTimeZone.add(c.Time_Zone__c);
            }
        }
        List<TimeZone_BusinessHour__mdt> lstTZBHmdt = [SELECT Id, DeveloperName, MasterLabel, Time_Zone_Label__c, Business_Hours__c FROM TimeZone_BusinessHour__mdt WHERE Time_Zone_Label__c IN: setConTimeZone];
        
        Map<Id, BusinessHours> mapBHrs = new Map<Id, BusinessHours>([SELECT Id, Name, IsActive FROM BusinessHours WHERE isActive=True]);
        Map<String, BusinessHours> mapBhrName = new Map<String, BusinessHours>();
        for(BusinessHours bh : mapBHrs.values()){
            if(!mapBhrName.containsKey(bh.Name)){
                mapBhrName.put(bh.Name, bh );
            }
        }
        Map<String, BusinessHours> mapTZoneBHrs = new Map<String, BusinessHours>();
        for(TimeZone_BusinessHour__mdt tb : lstTZBHmdt){
            //system.debug('Metadata: '+tb);
            if(!mapTZoneBHrs.containsKey(tb.Time_Zone_Label__c)){
                mapTZoneBHrs.put(tb.Time_Zone_Label__c, mapBhrName.get(tb.Business_Hours__c));
            }
        }
        mapTZoneBHrs.put('Default', mapBhrName.get('AMER'));
        for(Contact c : lstCon){
            if(c.Time_Zone__c!=NULL && mapTZoneBHrs.containsKey(c.Time_Zone__c) && mapTZoneBHrs.get(c.Time_Zone__c)!=NULL){
                c.BusinessHours__c = mapTZoneBHrs.get(c.Time_Zone__c).Id;
            } else if(c.Time_Zone__c == NULL){
                c.BusinessHours__c = mapTZoneBHrs.get('Default').Id;
            }
        }
        //system.debug('lst con'+lstCon);
    }
    /*
    END : Auto Populate business hours based on time zone selected on Contact
    */
}