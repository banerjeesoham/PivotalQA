/*******************************************************************************************************************
* Apex Class Name  : PortalNewCaseController
* Test Class Name  : PortalNewCaseController_TC
* Version          : 1.0
* Function         : Class is used to create a new case from Community
* Modification Log :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Hemavathi NM                 10/12/2017            Used to create case record from portal
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public without sharing class PortalNewCaseController {
    public static user curUser;
    public static Set<String> accountIds;
    public static Map<Id,AccountShare> mapAccountShare;

    public static void getContactRole(){
        accountIds =  new Set<String>();
        mapAccountShare = new Map<Id,AccountShare>();
        curUser = [SELECT Id,ContactId,AccountId,Profile.Name,ProfileId FROM User WHERE Id =: UserInfo.getUserID()];
        for(AccountShare acr : [Select Id,AccountId,CaseAccessLevel,ContactAccessLevel from AccountShare where userOrGroupId =: UserInfo.getUserID() and RowCause  <>  'ImplicitParent']){
            mapAccountShare.put(acr.AccountId,acr);
            accountIds.add(acr.AccountId);
        }
    }
   /* Get All entitlement of logged in user*/
    @AuraEnabled//Annotation to use method in lightning component
    public static List<Entitlement> getEntitlementList(){//Fetch data
        getContactRole();
        accountIds.add(curUser.AccountId);
        List<Entitlement> entitlementList = [SELECT Id,Name,AccountId,Startdate,EndDate,Type,Account.Name,Accountname__c , Status FROM Entitlement WHERE AccountId =:accountIds order by EndDate desc limit 1000];
        if(!entitlementList.isEmpty()){
            return entitlementList;
        }else{
            return null;
        }
    }
    /*Get All related Contacts*/
    @AuraEnabled
    Public static list<Contact> getRelatedContacts(String accountId){
        if(accountId != null && accountId !='None'){
            getContactRole();
            String userProfileId = DataValueMap__c.getInstance('PortalUserProfileId').Data_Value__c;
            String customerAdminProfileId = DataValueMap__c.getInstance('PortalManagerProfileId').Data_Value__c;
            String query = 'SELECT Id , Name , AccountId FROM contact WHERE Enable_Portal_User__c =: active and ';
            String contactId;
            Boolean active = true;
            
            if(!customerAdminProfileId.containsIgnoreCase(curUser.ProfileId)){
                    contactId =curUser.contactId;
                    query = query + ' Id =: contactId';
            }
            if(customerAdminProfileId.containsIgnoreCase(curUser.ProfileId)){
                if(curUser.accountId == accountId){
                    query = query + ' AccountId =: accountId';
                }else{
                    if(!mapAccountShare.isEmpty() && mapAccountShare.containsKey(accountId)){
                        AccountShare acr = mapAccountShare.get(accountId);
                        string role;
                        for( AccountContactRole acR1 : [Select Role from AccountContactRole where ContactId =: curUser.ContactId and AccountId =: accountId]){
                            role = acR1.Role;
                        }
                        if(role == 'Multiple PCN View All'){
                            query = query + ' AccountId =: accountId';
                        }else{
                            contactId =curUser.contactId;
                            query = query + ' Id =: contactId';
                        }
                    }
                }
            }
            query = query + ' limit 1000';
            List<Contact> listContact = Database.query(query);
            if(!listContact.isEmpty()){
                return listContact;
            }else{
                return null;
            }
        }
        return null;
    }
    /*Get Related Entitlement*/
    @AuraEnabled//Annotation to use method in lightning component
    public static List<Entitlement> getRelatedEntitlements(String accountId){//Fetch data
        if(accountId != null && accountId!='None'){
            getContactRole();
            accountIds.add(curUser.AccountId);
            List<Entitlement> entitlementList = [SELECT Id,Name,AccountId,Startdate,Status, EndDate,Type,Account.Name,Accountname__c FROM Entitlement WHERE AccountId =:accountId and Status = 'Active'];
            if(!entitlementList.isEmpty()){
                return entitlementList;
            }else{
                return null;
            } 
        }else{
            return null;
        }
        
    }
    
    /*Get All Account Associated */
    @AuraEnabled
    Public static list<Account> getAccountList(){
        List<Account> listAccount = new List<Account>();
        getContactRole();
        accountIds.add(curUser.AccountId);
        
        for(Account acc :[Select Name,Id from Account WHERE Id =:accountIds]){
            listAccount.add(acc);
        }
        if(!listAccount.isEmpty()){
            return listAccount;
        }else{
            return null;
        }
    }
    /*Create Case Record*/
    @AuraEnabled
    public static String createRecord (Case ca, List<String> fieldValue){
          try{
            if(ca != null){
                if(ca.EntitlementId != null){
                    ca.RecordTypeId = label.Technical;
                }else{
                    ca.RecordTypeId = label.NonTechnical;
                }
                ca.origin = 'Community';
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;
                ca.setOptions(dmo);
                insert ca;
                FeedItem fi = new FeedItem();
                fi.ParentId = ca.Id;
                System.debug('ca.C---'+ca.Case_Comments__c);
                fi.body = ca.case_Comments__c;
                fi.Type ='TextPost';
                fi.Visibility = 'Allusers';
                insert fi;
                
            }
             return null;
          }catch(Exception ex){
                
                ErrorLog.CreateER(ex);
             
           }
        return null;
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
     @AuraEnabled
    Public static map<String,list<String>> getAllDepFieldValue(String entId){
        Map<String,list<String>> mapDepenPicValues = new Map<String,list<String>>();
        mapDepenPicValues.put('ProductVersion' , new list<String>());
        mapDepenPicValues.put('Component' , new list<String>());
        mapDepenPicValues.put('SubComponent' , new list<String>());
        
        if(entId != null && entId != 'None'){
            String product = [Select Entitlement_Product_Name__c from Entitlement where id =: entId].Entitlement_Product_Name__c;
            System.debug('Product---->'+product);
            mapDepenPicValues.put('Product' , new list<String>{product});
            for(CaseDep__c caseDep : [Select ProductVersion__c,Component__c,Subcomponent__c,Product__c FROM CaseDep__c WHERE Product__c =:product]){
                if(caseDep.ProductVersion__c != null){
                    set<String> validate = new set<String>();
                    mapDepenPicValues.get('ProductVersion').add(caseDep.ProductVersion__c);
                    validate.addAll(mapDepenPicValues.get('ProductVersion'));
                    mapDepenPicValues.get('ProductVersion').clear();
                    mapDepenPicValues.get('ProductVersion').addAll(validate); 
                 }
                if(caseDep.Component__c != null){
                    set<String> validate = new set<String>();
                    mapDepenPicValues.get('Component').add(caseDep.Component__c);
                    validate.addAll(mapDepenPicValues.get('Component'));
                    mapDepenPicValues.get('Component').clear();
                    mapDepenPicValues.get('Component').addAll(validate);
              
                    
                }
                if(caseDep.Subcomponent__c != null){
                    set<String> validate = new set<String>();
                    mapDepenPicValues.get('SubComponent').add(caseDep.Subcomponent__c);
                    validate.addAll(mapDepenPicValues.get('SubComponent'));
                    mapDepenPicValues.get('SubComponent').clear();
                    mapDepenPicValues.get('SubComponent').addAll(validate);
                }
            }
            
            return mapDepenPicValues;
        }
        return null;
    }
    
    @AuraEnabled
    public static list<String> getSubCompValue(String cmpId){
        Set<String> subCompLst = new Set<String>();
        for(CaseDep__c caseDep : [Select ProductVersion__c,Component__c,Subcomponent__c,Product__c FROM CaseDep__c WHERE Component__c =:cmpId]){
            subCompLst.add(caseDep.Subcomponent__c);
        }
        if(!subCompLst.isEmpty()){
            list<string> subComList = new list<String>();
            subComList.addAll(subCompLst);
            return subComList;
        }
        return null;
    }
    
    @AuraEnabled
    public static user getCurrentUser(){
        return [SELECT Id,ContactId,AccountId,Account.Name,Email,Contact.Email, Contact.Name,Profile.Name,ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
    }
    
    @auraenabled
    Public static string  getSendSafetyURL(String accountId ,String caseId){
        if(caseId != null){
            list<Case> accountIds = [Select Id,AccountId from Case where Id=:caseId and AccountId !=null];
            accountId = accountIds[0].AccountId;
        }
        String APIkey_URL;// Stores APIKey and URL of SS
        Map<String,Sendsafely__c> sendSafelyCS = Sendsafely__c.getAll();
        if(accountId != null && accountId != 'None'){
            for(Account acc :[select Special_Handling__c from Account where id =:accountId]){
                String ssURL = acc.Special_Handling__c;
                if(sendSafelyCS.containsKey(ssURL)){
                    APIkey_URL = sendSafelyCS.get(ssURL).APIkey__c + '*' + sendSafelyCS.get(ssURL).ssURL__c;
                }else{
                    APIkey_URL += sendSafelyCS.get('Standard').APIkey__c + '*' + sendSafelyCS.get('Standard').ssURL__c;
                }
            }
        }
       return APIkey_URL;
    }
    
    @auraEnabled
    public static void  attachFileOnCase(String caseId,string body){
        FeedItem fi = new FeedItem();
        fi.Body= body;
        fi.Visibility='AllUsers';
        fi.ParentId=caseId;
        insert fi;
        System.debug('Fi'+fi);
    }
}