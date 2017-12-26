/*******************************************************************************************************************
* Apex Class Name  : PS_EntitlementTriggerHandler_TC
* Version          : 1.0
* Created Date     : 28 Oct 2017
* Function         : Class is used test  PS_EntitlementTriggerHandler - Entitlement create /update
* Modification Log : 
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Deepa Lakamanhalli            28/10/2017            Test Class to test  PS_EntitlementTriggerHandler
* ------------------------------------------------------------------------------------------------------------------
********************************************************************************************************************
*/
@isTest
Private Class PS_EntitlementTriggerHandler_TC{
    private testmethod static void casecountTestMethod(){
        TestDataUtil.dataValueMapCSData(); 
        case cObj = TestDataUtil.createTechnicalCase();
        System.assert(cObj.EntitlementId!=null);
        case cObj1 = TestDataUtil.createTechnicalCase();
        cObj1.AccountId = cObj.AccountId;
        cObj1.EntitlementId = cObj.EntitlementId;        
        cObj1.Resolution_Code__c ='Not Entitled';
        update cObj1;
        
        entitlement ent = new entitlement();
        ent.Id = cObj.EntitlementId;
        ent.Support_Exception__c = true;
        ent.AccountId = cObj.AccountId;     
        update ent;
        
        ent.Support_Exception__c = false;
        update ent;
    
    }
}