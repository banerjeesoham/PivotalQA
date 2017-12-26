@isTest
private class TaskTriggerSubjectUpdate_Test {

    /* Test Methods */
    static testMethod void test_TaskType_for_ISR() {
        runTest('Message Sent: Demo for PCF', true);
    }

    static testMethod void test_TaskType_for_user() {
        runTest('Reply: Email Sent by Customer', false);
    }
    static testMethod void test_LeadStatus_for_ISR() {
        runTest_for_LeadStatusUpdate('Message Sent: Demo for PCF', true);
    }

    /* Test Body */
    public static void runTest(String subjectStr, Boolean isSent) {
        Lead leadObj = TestDataFactory.createLead(true);
        Task taskObj = TestDataFactory.createTask(leadObj.Id, false);

        Profile p = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User u = TestDataFactory.createUser(p.Id, true);
        UserRole userRoleObj = TestDataFactory.createUserRole('AMER - ISR Regional Director');

        Test.startTest();
        TestDataFactory.assignUserRole(u.Id, userRoleObj.Id);
        Test.stopTest();

        System.runAs(u) {
            taskObj.Subject = subjectStr;
            insert taskObj;
        }

        /* Assert Statements */
        Task newTaskObj = [SELECT Id, Type FROM Task WHERE Id = :taskObj.id];
        if (isSent) {
            System.assertEquals('ISR-Email Sent', newTaskObj.Type, 'Task Object Type should be ISR-Email Sent, not ' + newTaskObj.Type);
        } else {
            System.assertEquals('ISR-Email Response Received', newTaskObj.Type, 'Task Object Type should be ISR-Email Response Received, not ' + newTaskObj.Type);
        }
    }
    public static void runTest_for_LeadStatusUpdate(String subjectStr, Boolean isSent) {

        Lead leadObj = new Lead();
        Task taskObj = new Task();

        Profile p = TestDataFactory.createProfile('Pivotal - Sales Rep');
        User u = TestDataFactory.createUser(p.Id, true);
        UserRole userRoleObj = TestDataFactory.createUserRole('AMER - ISR Regional Director');

        Test.startTest();
        TestDataFactory.assignUserRole(u.Id, userRoleObj.Id);
        Test.stopTest();

        System.runAs(u) {
            leadObj = TestDataFactory.createLead(true);
            taskObj = TestDataFactory.createTask(leadObj.Id, false);
            taskObj.Subject = subjectStr;
            insert taskObj;
        }

        /* Assert Statements */
        Task newTaskObj = [SELECT Id, Type FROM Task WHERE Id = :taskObj.id];
        Lead newLeadObj = [Select Id,Status from Lead where Id = :leadObj.id];
        if (isSent) {
            System.assertEquals('ISR-Email Sent', newTaskObj.Type, 'Task Object Type should be ISR-Email Sent, not ' + newTaskObj.Type);
        } else {
            System.assertEquals('ISR-Email Response Received', newTaskObj.Type, 'Task Object Type should be ISR-Email Response Received, not ' + newTaskObj.Type);
        }
        System.assertEquals('Working', newLeadObj.Status, 'Lead Status not updated ' + newLeadObj.Status);

    }
}