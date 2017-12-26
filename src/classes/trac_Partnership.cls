/* 
 * @description		Methods for the Parntership trigger.
 * @author			Merisha Shim, traction on demand
 * @date			02/25/2014
 *
 */ 

 /** THis method fires after partnerships have been created */
public with sharing class trac_Partnership {
	public static void updateAccountProgramWithNull(List<Partnership__c> newPartnerships) {
		
		Set<Id> acctListIds = new Set<Id>();

		for(Partnership__c p : newPartnerships) {
			acctListIds.add(p.Account__c);
		}
		List<Account> acctList = new List<Account>(); 
		List<Account> acctToUpdate = new List<Account>();
		
		if(!acctListIds.isEmpty()) {
			 acctList = [SELECT Id, Program__c FROM Account WHERE Id IN: acctListIds AND Program__c != null];
		}

		for(Account a : acctList) {
			a.Program__c = null;
			acctToUpdate.add(a);
		}

		if(!acctToUpdate.isEmpty()) {
			update acctToUpdate;
		}
	}
}