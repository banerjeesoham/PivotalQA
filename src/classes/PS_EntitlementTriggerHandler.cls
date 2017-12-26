/*******************************************************************************************************************
* Apex Class Name  : PS_EntitlementTriggerHandler
* Test Class Name  : PS_EntitlementTriggerHandler_TC
* Version          : 1.0
* Created Date     : 01 August 2017
* Function         : class is used to decrement and increment Support_Exception_Cases__c field count on account
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/01/2017            intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class PS_EntitlementTriggerHandler{
    //this method is used to revoke case count on realted account
    public static void countSupportExceptionGranted(List<Entitlement> lstEnt){
        Set<Id> setAccId = new Set<Id>();
        for(Entitlement e : lstEnt){
            setAccId.add(e.AccountId);
        }
        Map<Id, Account> mapAccToUpdate = new Map<Id, Account> ();
        Map<Id, Account> mapAccWithEnt = new Map<Id, Account>([Select Id, Support_Exceptions_Granted__c from Account where Id IN: setAccId]);
        
        List<Case> lstCaseWithEnt = [Select id, Accountid, Resolution_Code__c,EntitlementId, Entitlement.AccountId
                                    from Case WHERE Accountid IN: setAccId AND EntitlementId IN: lstEnt];
        Map<Id, List<Case>> mapAccWithCase = new Map<Id, List<Case>>();
        for(Case c : lstCaseWithEnt){
            if(c.AccountId!=NULL){
                if(!mapAccWithCase.containskey(c.AccountId)){
                    mapAccWithCase.put(c.AccountId, new List<Case>{c});
                } else {
                    List<Case> temp = mapAccWithCase.get(c.AccountId);
                    temp.add(c);
                    mapAccWithCase.put(c.AccountId, temp);
                }
            }
        }
        
        for(Entitlement e : lstEnt){            
            
            if( mapAccWithEnt.containskey(e.AccountId) && mapAccWithCase.containskey(e.AccountId) && mapAccWithCase.get(e.AccountId)!= NULL ){
                mapAccWithEnt.get(e.Accountid).Support_Exceptions_Granted__c = mapAccWithCase.get(e.AccountId).size();
                mapAccToUpdate.put(e.AccountId, mapAccWithEnt.get(e.Accountid));
            }
            
        }
        
        if(mapAccToUpdate.values()!=NULL && mapAccToUpdate.values().size()>0){
            update mapAccToUpdate.values();
        }
    }
    
    public static void countSupportExceptionRejected(List<Entitlement> lstEnt){
        Set<Id> setAccId = new Set<Id>();
        for(Entitlement e : lstEnt){
            setAccId.add(e.AccountId);
        }
        Map<Id, Account> mapAccToUpdate = new Map<Id, Account> ();
        Map<Id, Account> mapAccWithEnt = new Map<Id, Account>([Select Id, Support_Exceptions_Granted__c, Support_Exceptions_Rejected__c from Account where Id IN: setAccId]);
        
        List<Case> lstCaseWithEnt = [Select id, AccountId, Resolution_Code__c from Case WHERE Accountid IN: setAccId AND EntitlementId IN: lstEnt AND Resolution_Code__c ='Not Entitled'];
        Map<Id, List<Case>> mapAccWithCase = new Map<Id, List<Case>>();
        for(Case c : lstCaseWithEnt){
            if(c.AccountId!=NULL){
                if(!mapAccWithCase.containskey(c.AccountId)){
                    mapAccWithCase.put(c.AccountId, new List<Case>{c});
                } else {
                    List<Case> temp = mapAccWithCase.get(c.AccountId);
                    temp.add(c);
                    mapAccWithCase.put(c.AccountId, temp);
                }
            }
        }
        
        for(Entitlement e : lstEnt){            
            if( mapAccWithEnt.containskey(e.AccountId) && mapAccWithCase.containskey(e.AccountId) && mapAccWithCase.get(e.AccountId)!= NULL ){
                mapAccWithEnt.get(e.Accountid).Support_Exceptions_Rejected__c = mapAccWithCase.get(e.AccountId).size();
                if(mapAccWithEnt.get(e.Accountid).Support_Exceptions_Granted__c != NULL && mapAccWithEnt.get(e.Accountid).Support_Exceptions_Granted__c > 0 ){
                    mapAccWithEnt.get(e.Accountid).Support_Exceptions_Granted__c -= mapAccWithCase.get(e.AccountId).size();     
                }
                mapAccToUpdate.put(e.AccountId, mapAccWithEnt.get(e.Accountid));
            }

        }
        
        if(mapAccToUpdate.values()!=NULL && mapAccToUpdate.values().size()>0){
            update mapAccToUpdate.values();
        }
    }
}