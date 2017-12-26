@isTest
private class OpportunityLineItemTriggerOppTeam_Test {

    /* Test Methods */

    static testMethod void test_individual_team_member() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity opp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');

        User cnsRep = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion = TestDataFactory.createCNSRegion(cnsRep.Id, 'Pacific NorthWest');

        User oppOwner = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwner.Region__c = 'Pacific NorthWest';
        insert oppOwner;

        Test.startTest();

        System.runAs(oppOwner) {
            insert opp;

            OpportunityLineItem oppLineItem = TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false);
            insert oppLineItem;
        }

        Test.stopTest();

        List<OpportunityTeamMember> oppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, oppTeamMembers.size(), 'CNS Reps not on Opportunity Team');
    }

    static testMethod void test_cns_rep_opp_line_insert_ability() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity opp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');

        User cnsRep = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion = TestDataFactory.createCNSRegion(cnsRep.Id, 'Pacific NorthWest');

        User oppOwner = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwner.Region__c = 'Pacific NorthWest';
        insert oppOwner;

        System.runAs(oppOwner) {
            insert opp;

            OpportunityLineItem oppLineItem = TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false);
            insert oppLineItem;
        }

        Test.startTest();

        try {
            System.runAs(cnsRep) {
                OpportunityLineItem oppLineItem = TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false);
                insert oppLineItem;
            }
        } catch (Exception ex) {
            System.assert(false, 'CNS Rep unable to insert opp line');
        }

        Test.stopTest();
    }

    static testMethod void test_multiple_team_members() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity opp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User cnsRep1 = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion1 = TestDataFactory.createCNSRegion(cnsRep1.Id, 'Pacific NorthWest');

        User cnsRep2 = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion2 = TestDataFactory.createCNSRegion(cnsRep2.Id, 'Pacific NorthWest');

        User oppOwner = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwner.Region__c = 'Pacific NorthWest';
        insert oppOwner;

        Test.startTest();

        System.runAs(oppOwner) {
            insert opp;

            OpportunityLineItem oppLineItem = TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false);
            insert oppLineItem;
        }

        Test.stopTest();

        List<OpportunityTeamMember> oppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :opp.Id];
        System.assertEquals(2, oppTeamMembers.size(), 'CNS Reps not on Opportunity Team');
    }

    static testMethod void test_multiple_opportunities() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity northwestOpp = generateOpportunity();
        Opportunity southwestOpp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User cnsRepNorth = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion1 = TestDataFactory.createCNSRegion(cnsRepNorth.Id, 'Pacific NorthWest');

        User cnsRepSouth = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion2 = TestDataFactory.createCNSRegion(cnsRepSouth.Id, 'Pacific SouthWest');

        User oppOwnerNorth = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwnerNorth.Region__c = 'Pacific NorthWest';
        insert oppOwnerNorth;

        User oppOwnerSouth = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwnerSouth.Region__c = 'Pacific SouthWest';
        insert oppOwnerSouth;

        Test.startTest();

        System.runAs(oppOwnerNorth) {
            insert northwestOpp;
        }

        System.runAs(oppOwnerSouth) {
            insert southwestOpp;
        }

        List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
        oppLineList.add(TestDataFactory.createOpportunityLineItem(northwestOpp.Id, pbEntry.Id, 500.00, false));
        oppLineList.add(TestDataFactory.createOpportunityLineItem(southwestOpp.Id, pbEntry.Id, 500.00, false));

        insert oppLineList;

        Test.stopTest();

        List<OpportunityTeamMember> northwestOppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :northwestOpp.Id];
        System.assertEquals(1, northwestOppTeamMembers.size(), 'CNS Reps not on Opportunity Team');

        List<OpportunityTeamMember> southwestOppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :southwestOpp.Id];
        System.assertEquals(1, southwestOppTeamMembers.size(), 'CNS Reps not on Opportunity Team');
    }

    static testMethod void test_no_cns_rep_for_region() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity opp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User oppOwner = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwner.Region__c = 'Pacific NorthWest';
        insert oppOwner;

        Test.startTest();

        System.runAs(oppOwner) {
            insert opp;

            OpportunityLineItem oppLineItem = TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false);
            insert oppLineItem;
        }

        Test.stopTest();

        List<OpportunityTeamMember> oppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :opp.Id];
        System.assertEquals(0, oppTeamMembers.size(), 'CNS Reps on Opportunity Team');
    }

    static testMethod void test_multiple_line_inserts() {
        PricebookEntry pbEntry = generatePricebook();
        Opportunity opp = generateOpportunity();

        Profile salesProfile = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User cnsRep = TestDataFactory.createUser(salesProfile.Id, true);
        CNS_Region__c cnsRegion = TestDataFactory.createCNSRegion(cnsRep.Id, 'Pacific NorthWest');

        User oppOwner = TestDataFactory.createUser(salesProfile.Id, false);
        oppOwner.Region__c = 'Pacific NorthWest';
        insert oppOwner;

        Test.startTest();

        System.runAs(oppOwner) {
            insert opp;

            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            oppLineList.add(TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false));
            oppLineList.add(TestDataFactory.createOpportunityLineItem(opp.Id, pbEntry.Id, 500.00, false));

            insert oppLineList;
        }

        Test.stopTest();

        List<OpportunityTeamMember> oppTeamMembers = [SELECT Id FROM OpportunityTeamMember WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, oppTeamMembers.size(), 'CNS Reps not on Opportunity Team');
    }

    /* Private Methods */

    private static PricebookEntry generatePricebook() {
        Product2 product = TestDataFactory.createProduct2(true);
        return TestDataFactory.createPricebookEntry(product.Id, 5000.00, true);
    }

    private static Opportunity generateOpportunity() {
        Account acc = TestDataFactory.createAccount(true);
        return TestDataFactory.createOpportunity(acc.Id, false);
    }
}