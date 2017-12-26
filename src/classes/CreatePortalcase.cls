global class CreatePortalcase {
    public String selectedProduct{get;set;}    
    
    @AuraEnabled
    public static string createRecord (Case ca,string sub,string Severity,string Product1,string recordtype,string pry ,string products,string con,string acc,string ent,string enviornments,string Version,string components,string subcomponent){
        try{
            user[] u =[SELECT id,AccountId,ContactId,Profile.Name FROM User WHERE ContactId != '' and id=:Userinfo.getUserid()]  ;
            Entitlement[] en =[select accountid,Entitlement_Product_Name__c from Entitlement where id=:ent limit 1];
            //String prodIds = [Select Entitlement_Product_Name__c from Entitlement where id =: prodId].Entitlement_Product_Name__c;
        System.debug('con'+con);
            System.debug('candidate.Subject'+sub);
             System.debug('candidate.record'+recordtype);
            if(sub==null||sub==''){
               return label.Subjectreq; 
            }
            if(acc==null||acc==''){
	             return label.AccountReq;
            }
            if((enviornments==null||enviornments=='')&& recordtype=='technical'){
             return label.Environmentreq;
            }
            if((ent==null||ent=='' ) && recordtype=='technical'){
                System.debug('ent'+ent);
             return label.Entitelmentreq;
            }
            if(ca.Description==null||ca.Description==''){
            
             return label.DescriptionReq;
            
            }
            
             if(u.size()>0){
                if(recordtype=='technical' && u[0].Profile.Name == 'Customer Registered User') {
                    return label.Techcasevalidation ; 
                }
            }
            String csQueueId = DataValueMap__c.getInstance('CSQueueIds').Data_Value__c;
            String ceQueueId = DataValueMap__c.getInstance('CEQueueIds').Data_Value__c;
            if(ca != null||ca.Description!=null){
                
                if(recordtype=='Nontechnical'){
                    
                    ca.recordtypeid=label.Nontechnical ;
                    ca.Priority = 'Severity 3 - Minor';
                    ca.OwnerId = csQueueId ;
                    ca.subject=sub;
                    ca.Origin='Community';
                    ca.accountid=acc;
                    ca.contactid=con;
                    
                }
                else if(recordtype=='Technical'){
                    ca.recordtypeid=label.Technical ;
                    ca.OwnerId = ceQueueId ;
                    ca.entitlementid=ent;
                    ca.accountid=acc;
                    ca.contactid=con;
                    ca.Priority = Severity;
                    ca.Environment__c=enviornments;
                    ca.subject=sub;
                    ca.Origin='Community';
                    if(products != 'None'){
                        ca.Products__c=en[0].Entitlement_Product_Name__c;
                    }else{
                        ca.Products__c=null;
                    }
                    
                    ca.Versions__c=Version;
                    ca.Component__c=components;
                    ca.Sub_Component__c=subcomponent;
                    
                    
                }
                System.debug('ca-----'+ca);
                insert ca;
                
            }
            return null;
        } 
        
        catch (Exception ex){
            return ex.getMessage();
        }
        
    } 
    @AuraEnabled//Annotation to use method in lightning component
    public static List<Entitlement> getEntitlementList(String accountId){//Fetch data
        User userRec = [SELECT Id,ContactId , AccountId FROM User WHERE Id =: UserInfo.getUserID()];
        Map<Id,Id> accountContactIdsMap = new Map<Id,Id>();
        accountContactIdsMap.put(userRec.AccountId,userRec.ContactId);
        List<Id> accountIds = new List<Id>();
        accountIds.add(accountId);
        for(AccountContactRole__c acR:[SELECT Account__c FROM AccountContactRole__c WHERE User__c =:userRec.Id]){
            accountIds.add(acR.Account__c);
        }
        System.debug('accountIds----'+accountIds);
        List<Entitlement> entitlementList = [SELECT Id,Name,AccountId,Startdate,Status, EndDate,Type,Account.Name,Accountname__c  FROM Entitlement WHERE AccountId =:accountId and Status = 'Active'];
        if(!entitlementList.isEmpty()){
            return entitlementList;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    Public static list<Account> getAccountList(){
        List<Account> listAccount = new List<Account>();
        set<Id> accountIds = new set<Id>();
        String userId = userInfo.getUserId();
        User userRec = [SELECT Id,ContactId , AccountId FROM User WHERE Id =: UserInfo.getUserID()];
        accountIds.add(userRec.AccountId);
        for(AccountContactRole__c accRole : [SELECT Account__c from AccountContactRole__c where User__c =: userId and CaseAccessLevel__c != 'None']){
            accountIds.add(accRole.Account__c);
            System.debug('accountIds---'+accountIds);
        }
        
        System.debug('accountIds---'+accountIds);
        for(Account acc :[Select Name,Id from Account WHERE Id =:accountIds]){
            listAccount.add(acc);
        }
        System.debug('listAccount---'+listAccount);
        if(!listAccount.isEmpty()){
            return listAccount;
        }else{
            return null;
        }
    }//End Method
    @AuraEnabled
    Public static list<Contact> getContactList(String accountId){
        List<Contact> listContact = new List<Contact>();
        set<Id> contactIds = new set<Id>();
        String userId = userInfo.getUserId();
        User userRec = [SELECT Id,ContactId , AccountId ,Profile.Name FROM User WHERE Id =: UserInfo.getUserID()];
        contactIds.add(userRec.ContactId);
        System.debug('AccountIDs----'+accountId);
        for(AccountContactRole__c accRole : [SELECT Account__c,Contact__c from AccountContactRole__c where User__c =: userId and  Account__c =:accountId ]){
            contactIds.add(accRole.Contact__c);
            System.debug('contactIds---'+contactIds);
        }
       
        System.debug('contactIds---'+contactIds);
         List<Contact> contactLst = new List<Contact>();
        if(userRec.Profile.Name != 'Customer Community Manager'){
            contactLst = [Select Id ,name,AccountId from Contact where Id =:contactIds];
            System.debug('contactLst---'+contactLst);
            for(Contact con : contactLst){
                listContact.add(con);
            }
        }else{
            if(accountId == userRec.AccountId){
                contactLst = [Select Id ,name,AccountId from Contact where Id =:contactIds or AccountId =: userRec.AccountId];
            }else{
                contactLst = [Select Id ,name,AccountId from Contact where Id =:contactIds];
          
            }
            
            System.debug('contactLst---'+contactLst);
            for(Contact con : contactLst){
                listContact.add(con);
            }            
            
        }
        
        
        if(!listContact.isEmpty()){
            return listContact;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    Public static list<CaseDep__c> getdepList(String Prodid){
        String prodIds = [Select Entitlement_Product_Name__c from Entitlement where id =: prodId].Entitlement_Product_Name__c;
        List<CaseDep__c> casedep= [SELECT  ProductVersion__c  FROM CaseDep__c WHERE Product__c =:prodIds];
        System.debug('entitlementList---'+casedep.size());
        List<CaseDep__c> caseprodversion=new list<CaseDep__c>();
        for(CaseDep__c ca :casedep){
            if(ca.ProductVersion__c !=null){
                
                caseprodversion.add(ca);
            }
        }
        if(!caseprodversion.isEmpty()){
            return caseprodversion;
            
        }else{
            return null;
        }
    }
    @AuraEnabled
    Public static list<CaseDep__c> getcomponentList(String Prodid){
       String prodIds = [Select Entitlement_Product_Name__c from Entitlement where id =: prodId].Entitlement_Product_Name__c;
        List<CaseDep__c> casedep= [SELECT  Component__c FROM CaseDep__c WHERE Product__c =:prodIds];
        System.debug('entitlementList---'+casedep.size());
        set<string> unique=new set<string>();
        
        List<CaseDep__c> caseprodversion=new list<CaseDep__c>();
        for(CaseDep__c ca :casedep){
            if(ca.Component__c!=null&& !unique.contains(ca.Component__c)){
                
                unique.add(ca.Component__c);
                
                caseprodversion.add(ca);
            }
        }
        if(!caseprodversion.isEmpty()){
            return caseprodversion;
            
        }else{
            return null;
        }
    }
    @AuraEnabled
    Public static list<CaseDep__c> getsubcomponentList(String Prodid){
        System.debug('prodoid---'+prodid);
        String prodIds = [Select Entitlement_Product_Name__c from Entitlement where id =: prodId].Entitlement_Product_Name__c;
        List<CaseDep__c> casedep= [SELECT  Subcomponent__c FROM CaseDep__c WHERE Product__c =:prodIds];
        System.debug('entitlementList---'+casedep.size());
        List<CaseDep__c> caseprodversion=new list<CaseDep__c>();
        for(CaseDep__c ca :casedep){
            if(ca.Subcomponent__c!=null){
                
                caseprodversion.add(ca);
            }
        }
        if(!caseprodversion.isEmpty()){
            return caseprodversion;
            
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
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
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    Public static list<Entitlement> getProdList(String Prodid){
        System.debug('entitlementList---'+Prodid);
        List<Entitlement> entitlementList = [SELECT Entitlement_Product_Name__c ,id,name  FROM Entitlement WHERE id=:Prodid];
        
        if(!entitlementList.isEmpty()&&entitlementList[0].Entitlement_Product_Name__c!=null){
            return entitlementList;
        }else{
            return null;
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
}//End Class