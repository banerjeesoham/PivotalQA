/*******************************************************************************************************************
* Apex Class Name  : PS_CaseTriggerHandler
* Test Class Name  : PS_CaseTriggerHandler_Test
* Version          : 1.0
* Created Date     : 16 August 2017
* Function         : class is used to update case field Special_Handling_Instructions__c when case product eqauls 
Special_Handling_Instructions object product field which are related accounts
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/16/2017            Intial version
* Karthik.A.S               08/29/2017            Added logic to increase support_Exceptions_Granted__c,Support_Exceptions_Rejected__c values on realted account
* Richa Gupta               08/30/2017            Added logic to increase Support_Exceptions_Rejected__c value when Resolution Code equals Not-Entitled. 
* Karthik.A.S               09/01/2017            Added logic to update Special_Handling_Instructions__c when case product is changed
* Richa Gupta               09/14/2017            Added logic to increase support_Exceptions_Granted__c value when Support Exception is true on Entitlement. 
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class PS_CaseTriggerHandler{
    //This method is used update case field Special_Handling_Instructions__c when case product eqauls SpecialHandlingInstructions product
    public static void updatecase(){
        
        Boolean matchFound = false;
        set<id>accountids=new set<id>();
        list<case>caseupdate= new list<Case>();
        Map<Id,case> caseMap = new Map<Id,case>();
        Map<Id, List<Case>> accountCaseMap = new Map<Id,list<case>>();
        
        for(case caseobj: (List<case>) Trigger.New){
            accountids.add(caseobj.accountid);
            case oldCase = new case();
            
            if(Trigger.isUpdate)
                oldCase = (case) Trigger.oldMap.get(caseobj.id);           
                
            if((Trigger.isInsert ? (caseobj.Products__c!=null) : (oldCase.Products__c != caseobj.Products__c))){
                if(!accountCaseMap.containsKey(caseobj.accountid)){
                    accountCaseMap.put(caseobj.accountid,new list<Case>{caseObj});
                }else{
                    accountCaseMap.get(caseobj.accountid).add(caseObj);
                }
            }            
        }
        for(Special_Handling_Instructions__c splHandling: [select id,Handling_Instructions__c,Products__c,Account__c from Special_Handling_Instructions__c where Account__c in:accountCaseMap.keySet()]){

            if(accountCaseMap.containsKey(splHandling.Account__c)){
                for(Case caseObj : accountCaseMap.get(splHandling.Account__c)){                    
                    if(caseObj.Products__c!= null && splHandling.Products__c != null && caseObj.Products__c.contains(splHandling.Products__c)){
                        matchFound = true;                    
                        caseObj.Special_Handling_Instructions__c=splHandling.Handling_Instructions__c;                        
                    }
                    if(!matchFound){
                        caseObj.Special_Handling_Instructions__c = NULL;                       
                    }                    
                }
            }
        }
    }
    /*
    //This method is used for increase support_Exceptions_Granted__c,Support_Exceptions_Rejected__c values on realted account
    public static void incrementcountaccount(list<case>caseupdate){
        
        set<id>entid= new set<id>();
        set<id>accid= new set<id>();
        map<id,account>accupdate=new map<id,account>();
        map<id,Entitlement>Entupdate=new map<id,Entitlement>();
        for(case caseentid:caseupdate){
            entid.add(caseentid.Entitlementid);
            accid.add(caseentid.accountid);
        }
        list<Entitlement>ent=[select id,Accountid,Support_Exception__c from Entitlement where Support_Exception__c =true and id in:entid];
        if(!ent.isempty()){
            for(Entitlement entaccid :ent){
                Entupdate.put(entaccid.Accountid,entaccid);
            }
        }
        
        Map<Id,Account>  accountMap = new Map<Id,Account>([select id,support_Exceptions_Granted__c from account where id in:accid]);
        if(!accountMap.isempty()){
            for(case ca:caseupdate){
                Account accountRecord = new account();
                if(accountMap.containsKey(ca.AccountID)){
                    accountRecord = new account(id=ca.AccountID);
                    if(ca.Resolution_Code__c=='Not Entitled'){
                        if(accountRecord.Support_Exceptions_Rejected__c==null){
                            accountRecord.Support_Exceptions_Rejected__c=1;
                        }
                        else{
                            accountRecord.Support_Exceptions_Rejected__c=accountRecord.Support_Exceptions_Rejected__c+1;}
                    }
                    else if(Entupdate.containskey(ca.accountid)){
                        if(accountRecord.Support_Exceptions_Granted__c==null){
                            accountRecord.Support_Exceptions_Granted__c=1;
                        }
                        else{
                            accountRecord.Support_Exceptions_Granted__c=accountRecord.Support_Exceptions_Granted__c+1;}
                    }
                    accupdate.put(accountRecord.id,accountRecord);
                }
            }
        }
        if(!accupdate.isempty()){
        try{
            update accupdate.values();
           }
        catch(Exception e){
            ErrorLog.CreateER(e);// Catches Exception in Utility Class ErrorLog
           }
       }
        
    }
    */
public static void ChangeAccount(list<case> caseUpdated, Map<id,Case> caseOldMap){
        set<id>accid= new set<id>();
        map<id,account>accupdate=new map<id,account>();
        for(case caseObj:caseUpdated){
            accid.add(caseObj.accountId);
            accid.add(caseOldMap.get(caseObj.id).AccountId);
        }
        Map<Id,Account>  accountMap = new Map<Id,Account>([select id,support_Exceptions_Granted__c from account where id in:accid]);
            for(case cObj : caseUpdated){
                Account accountRecord = new account();
                if(accountMap.containsKey(cObj.AccountID)){
                    accountRecord = new account(id=cObj.AccountID);
                    if(accountRecord.Support_Exceptions_Granted__c==null){
                        accountRecord.Support_Exceptions_Granted__c=1;
                    }else{
                        if(accupdate.containsKey(accountRecord.id)){
                            accountRecord.Support_Exceptions_Granted__c = accupdate.get(accountRecord.Id).Support_Exceptions_Granted__c+1;
                        }else{
                            accountRecord.Support_Exceptions_Granted__c = accountRecord.Support_Exceptions_Granted__c+1;
                        }
                    }
                           }
                    accupdate.put(accountRecord.ID, accountRecord);
                
                if(accountMap.containsKey(caseOldMap.get(cObj.id).AccountId)){
                    Account accountRecord1 = accountMap.get(caseOldMap.get(cObj.id).AccountId);
                    accountRecord1.Support_Exceptions_Granted__c = accountRecord.Support_Exceptions_Granted__c - 1;
                    accupdate.put(accountRecord1.ID, accountRecord1);
                    }
                }
            if(!accUpdate.isEmpty()){ 
            try{
               update accUpdate.values();
            }
            catch(Exception e){
               ErrorLog.CreateER(e); // Exception is captured in Utility class Errorlog
              }
            }   
        }
    
    public static void afterInsertUpdateOperations(){
        List<Account> updateAccount= new List<Account>();
        set<id>accountIds= new set<id>();
        set<Id> caseIds = new set<Id>();
        set<String>productSet= new set<String>();
        list<Case> caseToUpdate = new list<Case>();
        for(case caseObj: (List<Case>)Trigger.New){
            if(Trigger.isInsert){
            productSet.add(caseObj.Products__c);
            accountIds.add(caseObj.accountId);
            }
            if(Trigger.isUpdate){
                case oldCase = (case) Trigger.OldMap.get(caseObj.Id);
                if(caseObj.Status != oldCase.Status && oldCase.Status=='On Hold' && oldCase.Sub_Status__c == 'RPS Hold' && caseObj.Status == 'Open'){
                    caseIds.add(caseObj.Id);
                }
            }
        }
        //Logic to populate Special handling field on case 
         if(Trigger.isAfter && Trigger.isInsert){ 
        //Logic to increment Account Count for Rejected and Granted
        Map<Id,Account> accountMap= new Map<Id,Account>([select id,support_Exceptions_Granted__c,Support_Exceptions_Rejected__c, (select id,Support_Exception__c from Entitlements where Support_Exception__c =true) , (select id,Handling_Instructions__c,Products__c,Account__c from Special_Handling_Instructions__r where Products__c =:productSet ) from account where id in:accountIds]);
        
        for(case ca:(List<Case>)Trigger.New){
            if(accountMap.containsKey(ca.AccountId)){
                Account acc = accountMap.get(ca.AccountId);
                List<Entitlement> entitleCount = acc.Entitlements;
                List<Special_Handling_Instructions__c> specialHandlingRecord = acc.Special_Handling_Instructions__r;
                if(ca.Resolution_Code__c=='Not Entitled'){
                    if(acc.Support_Exceptions_Rejected__c==null){
                        acc.Support_Exceptions_Rejected__c=1;
                    }
                    else{
                        acc.Support_Exceptions_Rejected__c=acc.Support_Exceptions_Rejected__c+1;
                    }   
                  
                }else if(entitleCount!= null && entitleCount.size()>0){
                    if(acc.Support_Exceptions_Granted__c==null){
                        acc.Support_Exceptions_Granted__c=1;
                    }
                    else{
                        acc.Support_Exceptions_Granted__c=acc.Support_Exceptions_Granted__c+1;
                    }
                    updateAccount.add(acc);
                }
                

            }   
        }
        if(!updateAccount.isempty()){
            try{
               update updateAccount;
            }catch(Exception e){
                ErrorLog.CreateER(e);// Exception is captured in Utility class Errorlog
            }
          }
        }
       
        if(!caseIds.isEmpty()){
            list<FeedItem> feedList = new list<FeedItem>();
            for(Id ids : caseIds){
                    FeedItem feed = new FeedItem();
                    feed.parentId = ids;
                    feed.body = 'Contact cleared by Compliance.';
                    feedList.add(feed);     
            }
            if(!feedList.isEmpty()){
                try{
                insert feedList;
                }catch(Exception e){
                    ErrorLog.CreateER(e); // Exception is captured in Utility class Errorlog
                }
            }
        }
    }
    @future
    public static void casesladatepopulate(set<id>ca){
    list<Case> listCaseToUpdate = new list<Case>();
        list<casemilestone> camile=[select id,targetdate,caseid,case.First_Response_Time__c , CompletionDate from casemilestone where CaseId in:ca and iscompleted=false];
        list<CaseMilestone> updCM = new List<CaseMilestone>();
            if(!camile.isempty()){
             for(casemilestone cm:camile){
                     Case caseObj = new case(id=cm.caseId );
                     System.debug('caseObj '+caseObj );
                     System.debug('caseObj '+cm.case.First_Response_Time__c );
                     if(cm.case.First_Response_Time__c==NULL){ 
                         caseObj.SLA_Target_date__c = cm.targetdate; //change as per new SLO design
                     } else {
                         system.debug('FR: '+caseObj.First_Response_Time__c);
                         cm.CompletionDate = cm.case.First_Response_Time__c; //change as per new SLO design
                         updCM.add(cm);
                     }
                     listCaseToUpdate.add(caseObj); 
                     
             }
             if(!listCaseToUpdate.isEmpty()){
                 try{
                    update listCaseToUpdate;
                 }catch(Exception e){
                    ErrorLog.CreateER(e); // Exception is captured in Utility class Errorlog
                 }
             }
             if(!updCM.isEmpty()){
                 try{
                    update updCM;
                    system.debug('CM :'+updCM);
                 }catch(Exception e){
                 system.debug('CM :'+e);
                    ErrorLog.CreateER(e); // Exception is captured in Utility class Errorlog
                 }
             }
         }
   }
   /*Creates post on the case when the case is created from EHSP support email-to-case. */
   public static void postFeedonEhspCase()
     {
        List<FeedItem> newComment = new List<FeedItem>();
        String emailAlias = DataValueMap__c.getInstance('EHSP support').Data_Value__c;
        for(Case ca: (list<Case>)Trigger.new)
        {
         Case caOld = (Case)Trigger.OldMap.get(ca.Id);
         if (ca.InboundEmailAlias__c !=null && caOld.InboundEmailAlias__c != ca.InboundEmailAlias__c && ca.InboundEmailAlias__c==emailAlias)
        {
                FeedItem com = new FeedItem();
                com.ParentId = ca.Id;
                com.Type= 'TextPost';
                com.Body= Label.FeedPostForEhspSupport+'\n'+'\n'+ca.SendSafely_URL__c;
                com.Visibility= 'InternalUsers';
                newComment.add(com) ;
        }
        }
        if(!newComment.isEmpty())
        {
            try{
                Insert newComment;
            }
            Catch(Exception e){
                ErrorLog.CreateER(e); // Exception is captured in Utility class Errorlog
            }
        }
        }
    
}