public with sharing class EntitlementListViewController{
   
    @AuraEnabled//Annotation to use method in lightning component
    public static List<Entitlement> getEntitlementList(){//Fetch data
         system.debug('@@in');
        User userRec = [SELECT Id,ContactId , AccountId FROM User WHERE Id =: UserInfo.getUserID()];
        Map<Id,Id> accountContactIdsMap = new Map<Id,Id>();
        accountContactIdsMap.put(userRec.AccountId,userRec.ContactId);
        List<Id> accountIds = new List<Id>();
        accountIds.add(userRec.AccountId);
        for(AccountContactRole__c acR:[SELECT Account__c FROM AccountContactRole__c WHERE User__c =:userRec.Id]){
            accountIds.add(acR.Account__c);
        }
        System.debug('accountIds----'+accountIds);
        //WHERE AccountId =:accountIds
        List<Entitlement> entitlementList = [SELECT Id,Name,AccountId,Startdate,EndDate,Type,Account.Name,Accountname__c , Status FROM Entitlement WHERE AccountId =:accountIds order by status DESC limit 100];
        if(!entitlementList.isEmpty()){
            return entitlementList;
        }else{
            return null;
        }
        
        //return [SELECT Id,Name,Accountid,startdate,enddate,Type,Accountname__c FROM Entitlement limit 10];
    } 
    @AuraEnabled//Annotation to use method in lightning component
    public static List<contact> contactlist(Id accountId , sObject target) {//Fetch data
        String userProfileId = DataValueMap__c.getInstance('PortalUserProfileId').Data_Value__c;
        system.debug('accountId---'+target);
        User usrRec = [Select Id, AccountId , ProfileId,ContactId from User where Id =:UserInfo.getUserId()];
        if(accountId !=null){
            List<Id> accountIds = new List<Id>();
            
            if(usrRec.accountId == accountId){
                accountIds.add(accountId);
                if(usrRec.ProfileId == userProfileId){
                    System.debug('profile');
                    return [SELECT Id,Name,Accountid FROM contact where id=:usrRec.ContactId];
                }
            }else{
                for(AccountContactRole__c acR:[SELECT Account__c FROM AccountContactRole__c WHERE User__c =:UserInfo.getUserID()]){
                    if(acR.Account__c == accountId){
                        accountIds.add(acR.Account__c); 
                    }
                }
            }
            if(accountIds.size()>0){
             System.debug('accountIds---'+accountIds);
             return [SELECT Id,Name,Accountid FROM contact where accountid=:accountIds or id =: usrRec.ContactId];
            }
        }
        return null;
    } 
    @AuraEnabled
    public static string createRecord (Case ca, Entitlement ents , string priority,string Product1,string recordtype,string pry,Id ent,Id con){      
         try{
             user[] u =[SELECT id,AccountId FROM User WHERE ContactId != '' and id=:Userinfo.getUserid()]  ;
                System.debug('enta---'+ents);
            Entitlement  enta=[select accountid from Entitlement  where id=:ent];
            if(ca != null){
                ca.recordtypeid=label.Technical ;
                ca.Priority=priority;
                if(enta != null){
                    ca.Entitlementid=ent;
                    ca.accountid=enta.accountid;
                }
                ca.contactid=con;
                //AssignmentRule assignRule = new AssignmentRule();
                //assignRule = [SELECT id FROM AssignmentRule WHERE sObjectType ='Case' and Active = true limit 1];
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true;
                ca.setOptions(dmo);
                insert ca;
            }
            return null;
         }catch (Exception ex){
             ErrorLog.CreateER(ex);//Exception captured in Utility Class Errorlog
         String error = ex.getMessage();
            if(error.contains('EntitlementId')){
                return 'You can not create a Case on Expire/InActive Entitlement';
            }else{
            return ex.getMessage();
            }
            
         }
    }
    @auraenabled
    Public static string  getaccountpickList(String accountId){
        
        List<account> accountlst =[select Special_Handling__c from account where id =:accountId];
        system.debug('accountlst'+accountlst);
        if(!accountlst.isEmpty()){
            string spl=accountlst[0].Special_Handling__c;
            return spl;
            
        }
        else{
            return null;
        }
    
    }
}