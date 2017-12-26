/* 
 * @description		Methods for the Account trigger.
 * @author			Merisha Shim, traction on demand
 * @date			02/25/2014
 *
 */ 
public with sharing class trac_Account {
	
	/* Method that creates a partnership when an account is created. */
	public static void createAndUpdatePartnershipAfterAccountInsert(List<Account> newAccts) {
		List<Account> acctsList = new List<Account>();
		Set<Id> programIds = new Set<Id>();
		
		for(Account a : newAccts) {
			if(a.Program__c != null) {
				acctsList.add(a);
				programIds.add(a.Program__c);
			}
		}
		Map<Id, Program__c> programNames = new Map<Id, Program__c>();
		if(programIds.size() > 0) {
			programNames = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN: programIds]);
		}
		//We need to get the contact Id of lead account that is related
		//List<Lead> leadLists = [SELECT Id, ConvertedContactId FROM Lead WHERE ConvertedAccountId IN : acctListIds];

		List<Partnership__c> partnershipsToInsert = new List<Partnership__c>();
		
		for(Account acct : acctsList) {
			Partnership__c partnership = new Partnership__c();
			partnership.Name = acct.Name + ' - ' + programNames.get(acct.Program__c).Name;
			partnership.Account__c = acct.Id;
			partnership.Program__c = acct.Program__c;
			partnership.Status__c = 'Approved';
			partnership.Active__c = true;
			partnership.Tier__c = 'Registered';
			partnershipsToInsert.add(partnership);
			
		}
		if(!partnershipsToInsert.isEmpty()) {
			insert partnershipsToInsert;
		}
		
		
	}

	
}