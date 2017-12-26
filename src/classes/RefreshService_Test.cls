@isTest
public class RefreshService_Test {

    /* Test Methods */

    static testMethod void activateAndSetPasswords_shouldDoThat() {
        deactivateUser('Falkirk IAD Integration');

        System.assertEquals(false, isUserActive('Falkirk IAD Integration'), 'Falkirk IAD Integration did not become inactive');

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        System.assertEquals(true, isUserActive('Falkirk IAD Integration'), 'Falkirk IAD Integration did not become active');
    }

    static testMethod void taxRegions_shouldBePrependedWithTest() {
        Company_Code__c code = new Company_Code__c();
        code.Name = 'This is Foo';
        code.Tax_Region__c = 'bar';
        insert code;

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        Company_Code__c updatedCode = [SELECT Name, Tax_Region__c FROM Company_Code__c WHERE Name = 'This is Foo'];
        System.assertEquals('TEST-bar', updatedCode.Tax_Region__c);
    }

    static testMethod void taxRegions_whenTheyAreAlreadyAppendedWithTest_shouldNotBePrependedWithMoreTests() {
        Company_Code__c code = new Company_Code__c();
        code.Name = 'This is Foo';
        code.Tax_Region__c = 'TEST-bar';
        insert code;

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        Company_Code__c updatedCode = [SELECT Name, Tax_Region__c FROM Company_Code__c WHERE Name = 'This is Foo'];
        System.assertEquals('TEST-bar', updatedCode.Tax_Region__c);
    }

    static testMethod void contactEmails_shouldBeChanged() {
        Account acc = TestDataFactory.createAccount(true);
        Contact ctt = getContact(acc.Id);

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        Contact updatedCtt = [SELECT Id, Email FROM Contact WHERE Id = :ctt.Id];
        System.assertEquals('fakeemail@sfdc.com', updatedCtt.Email, 'Contact email should be fake');
    }

    static testMethod void leadEmails_shouldBeChanged() {
        Lead lead = TestDataFactory.createLead(true);

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        Lead updatedLead = [SELECT Id, Email FROM Lead WHERE Id = :lead.Id];
        System.assertEquals('fakeemail@sfdc.com', updatedLead.Email, 'Lead email should be fake');
    }

    static testMethod void quoteShipTo_shouldBeChanged() {
        Account acc = TestDataFactory.createAccount(true);
        Contact ctt = getContact(acc.Id);
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id, true);
        zqu__Quote__c zQuote = ZTestFactory.makeQuote(opp, ctt);

        Test.startTest();
        List<String> users = new List<String>{'Falkirk IAD Integration'};
        RefreshService.refresh(users);
        Test.stopTest();

        zqu__Quote__c updatedQuote = [SELECT Id, Ship_Contact_Email__c FROM zqu__Quote__c WHERE Id = :zQuote.Id];
        System.assertEquals('fakeEmail@zuora.com', updatedQuote.Ship_Contact_Email__c, 'Ship to email should be fake');
    }

    /* Private Methods */

    private static boolean isUserActive(String name) {
        User u = [SELECT Id, isActive FROM User WHERE Name = :name];
        return u.isActive;
    }

    private static void deactivateUser(String userName) {
        User u = [SELECT Id FROM User WHERE Name = :userName];
        u.isActive = false;
        update u;
    }

    private static Contact getContact(Id accId) {
        //This Method is in use because of a terrible trigger Zuora has us using
        Contact ctt1 = TestDataFactory.createContact(accId, true);
        Contact ctt2 = TestDataFactory.createContact(accId, false);
        ctt2.LastName = 'Fake';
        ctt2.Email = 'ZuoraSux@hotmail.com';
        insert ctt2;
        return ctt1;
    }
}