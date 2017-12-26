@isTest
private class trac_Account_Test {
	
	@isTest static void createPartnershipsAfterAccountInsertTest() {
		//create A Program
		Program__c program = new Program__c(Name = 'Test Program');
		insert program;

		//create an Account that references the program (this theorectically happens after the lead gets converted)
		Account acct = new Account(Name='Account Test', Type = 'Analyst', Program__c = program.Id);
		insert acct;

		List<Partnership__c> partnerships = [SELECT Id, Account__c, Program__c, Status__c FROM Partnership__c];

		System.assertEquals(partnerships.size(), 1);
		System.assertEquals(partnerships[0].Account__c, acct.Id);
		System.assertEquals(partnerships[0].Program__c, program.Id);
		System.assertEquals(partnerships[0].Status__c, 'Approved');

		acct = [SELECT Id, Program__c FROM Account WHERE Id =: acct.Id];

		System.assertEquals(acct.Program__c, null);
	}
	
	@isTest static void createPartnershipsAfterAccountUpateTest() {
		//create A Program
		Program__c program = new Program__c(Name = 'Test Program');
		insert program;
		Program__c program2 = new Program__c(Name='2nd Program Test');
		insert program2;

		//create an Account that references the program (this theorectically happens after the lead gets converted)
		Account acct = new Account(Name='Account Test', Type = 'Analyst', Program__c = program.Id);
		insert acct;

		List<Partnership__c> partnerships = [SELECT Id, Account__c, Program__c, Status__c, Name FROM Partnership__c];

		System.assertEquals(partnerships.size(), 1);
		System.assertEquals(partnerships[0].Account__c, acct.Id);
		System.assertEquals(partnerships[0].Program__c, program.Id);
		System.assertEquals(partnerships[0].Status__c, 'Approved');
		System.assertEquals(partnerships[0].Name, 'Account Test - Test Program');

		acct = [SELECT Id, Program__c FROM Account WHERE Id =: acct.Id];

		System.assertEquals(acct.Program__c, null);

		
		acct.Program__c = program2.Id;
		update acct;

		List<Partnership__c> partnerships2 = [SELECT Id, Account__c, Program__c, Status__c FROM Partnership__c];
		System.assertEquals(partnerships2.size(), 2);
		acct = [SELECT Id, Program__c FROM Account WHERE Id =: acct.Id];

		System.assertEquals(partnerships2[0].Account__c, acct.Id);
		System.assertEquals(partnerships2[1].Account__c, acct.Id);

		System.assertEquals(acct.Program__c, null);
	}
	
}