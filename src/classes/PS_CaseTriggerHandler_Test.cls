@isTest
Private class PS_CaseTriggerHandler_Test {
        static testMethod  void  technicalCase(){
            TestDataUtil.dataValueMapCSData(); 
            Case cObj = TestDataUtil.createTechnicalCase();
            System.assert(cObj.Id !=null , 'Failed to create Technical Case');  
        }
    
        static testMethod void nonTechnicalCase(){
            TestDataUtil.dataValueMapCSData(); 
            Case cObjNT = TestDataUtil.createNonTechnicalCase();
            System.assert(cObjNT.Id !=null , 'Failed to create Non-Technical Case');
            System.assertEquals('Severity 1 - Critical', cObjNT.Priority);
            Account acc = TestDataUtil.createAccount();
            System.assert(acc.Id !=null , 'Failed to create Account');
            Entitlement en = TestDataUtil.createEntitlement(acc.Id);
            List<Entitlement> entitleCount= acc.Entitlements;
            system.assert(en.Id!=null,'Entitlement is not created');
            system.assert(entitleCount.size()!=1,'Entitlemet count is not 1');
            en.Support_Exception__c = true;
            update en;
            
            cObjNT.AccountId = acc.Id;
            update cObjNT;
            Contact con= [select Id,RPS_Status__c from Contact where Id=:cObjNT.ContactId];
            con.RPS_Status__c='Red';
            Update con;
            
            con.Cleared_by_Compliance__c = true;
            Update con;
            
            cObjNT.InboundEmailAlias__c=DataValueMap__c.getInstance('EHSP Escalations').Data_Value__c;
            update cObjNT;
            
            cObjNT.InboundEmailAlias__c=DataValueMap__c.getInstance('EHSP support').Data_Value__c;
            update cObjNT;
            
            case ca = new Case();
            ca.Subject ='Test Case';
            ca.AccountId = acc.Id;
            ca.contactId = cObjNT.ContactId;
            ca.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Non-Technical').getRecordTypeId(); 
            ca.Priority = 'Severity 2 - Major';
            insert ca;
            
            System.assertEquals(acc.Id, cObjNT.AccountId);   
            System.assertEquals(acc.Special_Handling__c, cObjNT.Special_Handling__c);
        }
}