public with sharing class Z_CA_TriggerHandler {

	public void onBeforeInsert(List<Zuora__CustomerAccount__c> newCAs) {
		
		for (Zuora__CustomerAccount__c ca : newCAs) {
			if (ca.CRM_Bill_To_Contact_Id__c != null) {
				ca.CRM_Bill_To_Contact__c = ca.CRM_Bill_To_Contact_Id__c; 
			}
			if (ca.CRM_Sold_To_Contact_Id__c !=null) {
				ca.CRM_Sold_To_Contact__c = ca.CRM_Sold_To_Contact_Id__c; 
			}
		}
	}

}