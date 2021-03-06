@isTest
public class TestDataUtil {
    public static case createTechnicalCase(){
        //Create account
       // Account acc = createAccount();
        //Create contact
        Contact con = createContact();
        System.assert(con.Id != null);
        Entitlement ent = createEntitlement(con.AccountId);
        case cObj = new case();
        cObj.Subject = 'Ignore Test Case';
        cObj.Description ='Ignore Test Case creation via Test Class';
        cObj.ContactId = (con !=null ? con.Id :null);
        cObj.AccountId = (con.AccountId!=null ? con.AccountId :null);
        cObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical').getRecordTypeId();
        cObj.EntitlementId = ent.Id;
        cObj.Products__c='Alpine Chorus for Pivotal Data Suite';
        cObj.Versions__c='2.4';
        cObj.Priority='Severity 1 - Critical'; 
        insert cObj;
        System.assert(cObj.Id != null);
        
        return cObj;
    }
    public static case createNonTechnicalCase(){
         //Create account
       // Account acc = createAccount();
        //Create contact
        Contact con = createContact();
        
        case cObj = new case();
        cObj.Subject = 'Ignore Test Case';
        cObj.Description ='Ignore Test Case creation via Test Class';
        cObj.ContactId = (con !=null ? con.Id : null);
        cObj.AccountId = (con!=null ? con.AccountId:null);
        cObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Non-Technical').getRecordTypeId();
        cObj.Resolution_Code__c='Not Entitled';
        cObj.Priority='Severity 1 - Critical'; 
        cObj.Products__c='Alpine Chorus for Pivotal Data Suite';
        insert cObj;
        System.assert(cObj.Id != null);
        
        return cObj;
        
    }
    
    public static Case createCaseByPortalUser(User portalUser){
        case cObj = new case();
        cObj.Subject = 'Ignore Test Case';
        cObj.Description ='Ignore Test Case creation via Test Class';
        cObj.ContactId = (portalUser.ContactId !=null ? portalUser.ContactId : null);
        cObj.AccountId = (portalUser.AccountId !=null ? portalUser.AccountId : null);
        cObj.Priority = 'Severity 3 - Minor'; 
        cObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Non-Technical').getRecordTypeId();
        insert cObj;
        System.assert(cObj.Id != null);
        
        return cObj;
    }
    
    public static account createAccount(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Type = 'Customer';
        insert acc;
        System.assert(acc.Id != null);
        return acc;
    }
    public static contact createContact(){
        // Retrieve Default Business Hour
        BusinessHours busHrs = [select Id, Name FROM BusinessHours LIMIT 1];
        system.assert(busHrs.Id != null);
        
        Account acc = createAccount();
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'Test@123.com';       
        con.BusinessHours__c = busHrs.Id;
        con.AccountId = (acc !=null ? acc.Id : null);
        con.mailingcountry = 'India';
        insert con;
        System.assert(con.Id != null);
        return con;
    }
    public static contact createContact(Id accId){
        // Retrieve Default Business Hour
        BusinessHours busHrs = [select Id, Name FROM BusinessHours LIMIT 1];
        system.assert(busHrs.Id != null);
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'Test@123.com';        
        con.BusinessHours__c = busHrs.Id;
        con.AccountId = (accId !=null ? accId : null);
        insert con;
        System.assert(con.Id != null);
        return con;
    }
    public static AccountContactRole createAccountContactRole(Id accId, Id conId){
        //Contact con = createContact();
        AccountContactRole rol = new AccountContactRole();
        rol.AccountId = accId;
        rol.ContactId = conId;
        rol.Role ='Multiple PCNs';
        insert rol;
        return rol;
    }
    public static contact createPortalContact(){
        // Retrieve Default Business Hour
        BusinessHours busHrs = [select Id, Name FROM BusinessHours LIMIT 1];
        system.assert(busHrs.Id != null);
        
        Account acc = createAccount();
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.Email = 'Testdata_TC@123.com';        
        con.BusinessHours__c = busHrs.Id;
        con.Enable_Portal_User__c = true;
        con.MailingCountry='India';
        con.AccountId = (acc !=null ? acc.Id : null);
        insert con;
        System.assert(con.Id != null);
        return con;
    }
    public static entitlement createEntitlement(Id accId){
        // Retrieve SLA Process
        ProductEntitlementMap__c pMap = createProductEntitlement();
        SlaProcess sla = [select Id, Name FROM SlaProcess LIMIT 1];
        system.assert(sla.id!=null);
        //Account acc = createAccount();
        Entitlement ent= new Entitlement();
        ent.Name = 'Test Entitlement';
        ent.StartDate = Date.today().addDays(-1);
        ent.EndDate = Date.today().addDays(1);
        ent.SlaProcessId = sla.Id;
        ent.AccountId = (accId!=null ? accId:null);
        ent.ProductEntitlementMap__c = pMap.Id;
        insert ent;
        
        System.assert(ent.Id != null);
        return ent;
    }

    public static Special_Handling_Instructions__c createSpecialHandling(Id accId){
        //Account acc = createAccount();
        Special_Handling_Instructions__c sp = new Special_Handling_Instructions__c();
        sp.Handling_Instructions__c = 'Test Ignore Handling Instructions';
        sp.Products__c = 'Alpine Chorus for Pivotal Data Suite';
        sp.Account__c = (accId !=null ? accId:null);
        insert sp;
        System.assert(sp.Id != null);
        return sp;
    }
    public static CaseDep__c createCaseDep(){
        
        CaseDep__c casde = new CaseDep__c(Name='Test CaseDep',Component__c='Test Component', Product__c='Alpine Chorus for Pivotal Data Suite', ProductVersion__c='Test ProductVersion',  Subcomponent__c='Test Subcomponent');
        
        insert casde;
        return casde;
    }
    
    public static ProductEntitlementMap__c createProductEntitlement(){
        SlaProcess sla = [select Id, Name FROM SlaProcess WHERE Name='Custom SLO Handling' LIMIT 1];
        ProductEntitlementMap__c proEnt = new ProductEntitlementMap__c(Name='Test', Entitlement_Process__c = sla.Name, Product_SKU__c='Test',SFDC_Product_Name__c='Alpine Chorus for Pivotal Data Suite',Products__c='Alpine Chorus for Pivotal Data Suite');
        insert proEnt;
        System.assert(proEnt.Id != null);
        return proEnt;
    }
    
    
    public static List<Profile> getProfiles(){
        return [Select Id from Profile WHERE Name IN ('Pivotal - Community Manager','Pivotal - Community User') ORDER BY Name]; 
    }
    
    public static User createPortalUser(){
        Contact c = createContact();
        List<Profile> lstProfile = getProfiles();
        User portalUser = new User( ContactId=c.Id,FirstName =c.FirstName, LastName=c.LastName, Email=c.Email, UserName=c.Email, ProfileId= lstProfile[0].Id, LanguageLocaleKey='en_US', TimeZoneSidKey='America/Los_Angeles', EmailEncodingKey = 'ISO-8859-1', LocaleSidKey = 'en_US', alias=PS_ContactTriggerHandler.generateRandomString(6,c.FirstName+c.LastName), isActive= true );
        insert portalUser;
        System.assert(portalUser.Id!=NULL);
        return portalUser;
    }
    
    public static void dataValueMapCSData(){
        
        List<Profile> lstProfile = getProfiles();
        List<DataValueMap__c>  csDataList =  new List<DataValueMap__c>();
        csDataList.add(new DataValueMap__c(Name = 'PortalManagerProfileId', Data_Value__c = lstProfile[0].Id));
        csDataList.add(new DataValueMap__c(Name = 'PortalUserProfileId', Data_Value__c = lstProfile[1].Id)); 
        csDataList.add(new DataValueMap__c(Name = 'ErrorOnCloseCaseUpdate', Data_Value__c = 'You can not modify closed case.'));
        csDataList.add(new DataValueMap__c(Name = 'customerCaseStatus', Data_Value__c = 'Closed,Solved,In Progress'));
        csDataList.add(new DataValueMap__c(Name = 'Expired', Data_Value__c = 'Expired'));
        csDataList.add(new DataValueMap__c(Name = 'active', Data_Value__c = 'active'));
        csDataList.add(new DataValueMap__c(Name = 'ArticleTypes', Data_Value__c = 'a42'));
        csDataList.add(new DataValueMap__c(Name = 'bypassModifyClosedCase', Data_Value__c = 'false'));
        csDataList.add(new DataValueMap__c(Name = 'EHSP support', Data_Value__c = 'ehsp.scqa@pivotal.io'));
        csDataList.add(new DataValueMap__c(Name = 'EHSP Escalations', Data_Value__c = 'ehsp-escalations.scqa@pivotal.io'));
        csDataList.add(new DataValueMap__c(Name = 'OnDemandaccountAlias', Data_Value__c = 'ondemand-support.scqa@pivotal.io'));        

        insert csDataList;
        
        List<Sendsafely__c>  csDataList2 =  new List<Sendsafely__c>();
        csDataList2.add(new Sendsafely__c(Name = 'EH - Executive Handling', APIkey__c = 'Te7Eu6BATD83CCSXQT4pCh7iQokrtFFmYzSaFrrSd2s',ssURL__c = 'https://securefiles-sp.pivotal.io/'));
        csDataList2.add(new Sendsafely__c(Name = 'Standard', APIkey__c = 'hnU_jQ5NeLBaevTcgb-mgJWYaJzC_hmUsUeHYBaPI1I', ssURL__c = 'https://securefiles.pivotal.io/'));
        insert csDataList2;
        
        List<PortalUserCreationMap__c>  csDataList1 =  new List<PortalUserCreationMap__c>();
        csDataList1.add(new PortalUserCreationMap__c(Name = 'contactId', Source__c = 'Id'));
        csDataList1.add(new PortalUserCreationMap__c(Name = 'Country__c', Source__c = 'Country__c')); 
        csDataList1.add(new PortalUserCreationMap__c(Name = 'Email', Source__c = 'Email'));
        csDataList1.add(new PortalUserCreationMap__c(Name = 'FirstName', Source__c = 'FirstName')); 
        csDataList1.add(new PortalUserCreationMap__c(Name = 'IsActive', Source__c = 'Enable_Portal_User__c'));
        csDataList1.add(new PortalUserCreationMap__c(Name = 'LanguageLocaleKey', Source__c = 'Language__c')); 
        csDataList1.add(new PortalUserCreationMap__c(Name = 'LastName', Source__c = 'LastName'));
        csDataList1.add(new PortalUserCreationMap__c(Name = 'LocaleSidKey', Source__c = 'Language__c')); 
        csDataList1.add(new PortalUserCreationMap__c(Name = 'Pivotal_Customer_Number__c', Source__c = 'Pivotal_Customer_Number__c'));
        csDataList1.add(new PortalUserCreationMap__c(Name = 'TimeZoneSidKey', Source__c = 'Time_Zone__c')); 
        csDataList1.add(new PortalUserCreationMap__c(Name = 'Username', Source__c = 'Email'));
        insert csDataList1;
        
        List<RelatedCaseFieldMapping__c>  rcFieldDataList =  new List<RelatedCaseFieldMapping__c>();
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'RecordTypeId', Destination__c = 'RecordTypeId', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'AccountId', Destination__c = 'AccountId', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Case_Type__c', Destination__c = 'Case_Type__c', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'ContactId', Destination__c = 'ContactId', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'CSR_Hand_Off_to__c', Destination__c = 'CSR_Hand_Off_to__c', IsTechnical__c= false, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Customer_Service_Category__c', Destination__c = 'Customer_Service_Category__c', IsTechnical__c= false, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Entitlementid', Destination__c = 'Entitlementid', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Environment__c', Destination__c = 'Environment__c', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Id', Destination__c = 'ParentId', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Priority', Destination__c = 'Priority', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Products__c', Destination__c = 'Products__c', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Related_KB_Article__c', Destination__c = 'Related_KB_Article__c', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Resolution_Code__c', Destination__c = 'Resolution_Code__c', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Resolution__c', Destination__c = 'Resolution__c', IsTechnical__c= true, isNonTechnical__c = false));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Subject', Destination__c = 'Subject', IsTechnical__c= true, isNonTechnical__c = true));
        rcFieldDataList.add(new RelatedCaseFieldMapping__c(Name = 'Versions__c', Destination__c = 'Versions__c', IsTechnical__c= true, isNonTechnical__c = false));
        
        insert rcFieldDataList;
        
        List<PortalObjectAccess__c> lstPortalAccess = new List<PortalObjectAccess__c>();
        lstPortalAccess.add(new PortalObjectAccess__c(Name='00e29000000DhbOAASMultiplePCNViewAll', Role__c='Multiple PCN View All',rank__c=1, Account__c='Read',Case__c='Read',Contact__c='Read', Entitlement__c='Read',Opportunity__c='None'));
        lstPortalAccess.add(new PortalObjectAccess__c(Name='00e29000000DhbOAASMultiplePCNs', Role__c='MultiplePCNs',rank__c=2, Account__c='Read',Case__c='None',Contact__c='None', Entitlement__c='Read',Opportunity__c='None'));
        
        insert lstPortalAccess;
        
        
        
    }
    
    
        
    public static EmailMessage createEmailMessage(Case cObj, String status, Boolean isIncoming , String toAddress ){
           // Retrieve Default Business Hour
           
           account acc = createAccount();
           
           
           contact con = createContact();
           con.email = 'test@email.com';
           con.accountid = acc.id;
           update con;
           
           
           BusinessHours busHrs = [select Id, Name FROM BusinessHours LIMIT 1];
           System.assert(busHrs.Id !=null);
           List<DataValueMap__c>  csDataList =  new List<DataValueMap__c>();
           
           csDataList.add(new DataValueMap__c(Name = 'OnDemandaccountAlias', Data_Value__c = ';ondemand-support.scqa@pivotal.io;'));
           csDataList.add(new DataValueMap__c(Name = 'OnDemandaccountId', Data_Value__c = cObj.AccountId));
           csDataList.add(new DataValueMap__c(Name = 'PWSaccountAlias', Data_Value__c = ';ondemand-support.scqa@pivotal.io;'));
           //csDataList.add(new DataValueMap__c(Name = 'PWSaccountId', Data_Value__c = cObj.AccountId));
           csDataList.add(new DataValueMap__c(Name = 'PWSaccountId', Data_Value__c = con.AccountId));
           csDataList.add(new DataValueMap__c(Name = 'DefaultBusHrs', Data_Value__c = busHrs.Id));
           csDataList.add(new DataValueMap__c(Name = 'Expired', Data_Value__c = 'Expired'));
           csDataList.add(new DataValueMap__c(Name = 'active', Data_Value__c = 'active'));
           insert csDataList;
        
           
           EmailMessage mail = new EmailMessage();
            mail.fromaddress= 'test@email.com';
            mail.FromName= 'Jack,Johnson';
            mail.toAddress = 'ondemand-support.scqa@pivotal.io';
            mail.subject = ' Test Message';
            mail.TextBody= 'This is the message body ';
            mail.parentid=cObj.id;
            mail.incoming=isIncoming;
            mail.Status=status;
            insert mail;
            
        System.assert(mail.id != null);
        return mail;
   }
   
    public static feedItem createFeedItem(String parId,String visible){
        FeedItem feed =new FeedItem();
        feed.parentId = parId;
        feed.body = 'TestFeed';
        feed.type ='TextPost';
        feed.Visibility=visible;       
        insert feed;
        
        return feed;
    }
    public static feedComment createfeedComment(Id parId){
        FeedComment fc = new FeedComment();
        fc.CommentBody = 'legal test';
        fc.FeedItemId = parId;   // please add this
        insert fc;        
        return fc;
    }
    
    public static Zuora__Subscription__c createSubscriptions(Id accId){
        Zuora__Subscription__c subs = new Zuora__Subscription__c();
        subs.Name ='Test Subscription';
        subs.Zuora__Account__c = accId;
        //subs.Zuora__Status__c = 'Cancelled';
        insert subs;
        system.assert(subs.Id!=NULL, 'error creation');
        return subs;
    }
    
    public static Zuora__Product__c createSubscriptionProduct(){
        Zuora__Product__c p = new Zuora__Product__c();
        p.Zuora__SKU__c = 'Test';
        insert p;
        return p;
    }
    
    public static Zuora__SubscriptionProductCharge__c createSubscriptionProductCharge(Id accId, Id prdtId){
        Zuora__SubscriptionProductCharge__c subsPrdt = new Zuora__SubscriptionProductCharge__c();
        subsPrdt.Name ='Test Subscription';
        subsPrdt.Zuora__Account__c = accId;
        subsPrdt.Zuora__Product__c = prdtId;
        insert subsPrdt;
        system.assert(subsPrdt.Id!=NULL, 'error creation');
        return subsPrdt;
    }
}