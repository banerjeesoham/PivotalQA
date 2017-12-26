/*
/*******************************************************************************************************************
* Apex Class Name  : PS_ContactTriggerHandler_TC
* Version          : 1.0
* Created Date     : 28 Oct 2017
* Function         : Class is used test PS_ContactTriggerHandler - create and update Portal User through Contact
* Modification Log : 
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Deepa Lakamanhalli            28/10/2017            Test Class to test PS_ContactTriggerHandler
* ------------------------------------------------------------------------------------------------------------------
********************************************************************************************************************
*/
@isTest
public class PS_ContactTriggerHandler_TC {
    static testmethod void createPortalUserTest(){
        Test.startTest();
        TestDataUtil.dataValueMapCSData();
        Contact rCont = TestDataUtil.createPortalContact();
        system.debug('contact : '+rCont+'-'+Contact.AccountId);
        system.assert(rCont !=null);
        system.assert(rCont.Name ==null, rCont.Name);
        User u = [Select id,ContactId, AccountId from User where contactId=:rCont.Id];
        System.debug('user created: '+u);
        Case cas = TestDataUtil.createCaseByPortalUser(u);
        checkRecursive.checkContact = true;
        rCont.BusinessHours__c= [select Id, Name FROM BusinessHours where isActive=true ORDER BY Name LIMIT 1].Id;
        rCont.Customer_Admin__c = true;
        rCont.MailingCountry = 'India';
        update rCont;
        Case cs = TestDataUtil.createTechnicalCase();
        cs.ContactId = rCont.Id;
        update cs;
        checkRecursive.checkContact = true;
        rCont.View_Account_Cases__c = true;
        rCont.BusinessHours__c=[select Id, Name FROM BusinessHours where isActive=true and name='EMEA' ORDER BY Name LIMIT 1].Id;
        update rCont;
        Test.stopTest();
    }
}