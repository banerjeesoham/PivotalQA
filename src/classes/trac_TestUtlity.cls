@isTest
public class trac_TestUtlity {
	
	/**********************************************************************************/
	/************************** 	 Utility Methods	   ****************************/
	/**********************************************************************************/
	public static Opportunity createOpportunity(){
		Opportunity newOpportunity = new Opportunity(
			Name='Traction Test',
			StageName = 'Test',
			CloseDate = Date.today()
		);
		insert newOpportunity;

		return newOpportunity;
	}

	public static Product2 createProduct(){
		Product2 newProduct = new Product2(
			Name = 'Traction Test Product',
			Selling_Motion__c = 'Support',
			IsActive = true
		);
		insert newProduct;

		return newProduct;
	}

	public static Pricebook2 createPricebook(){
		Pricebook2 newPricebook = new Pricebook2(
			Name = 'Traction Pricebook'
		);
		insert newPricebook;

		return newPricebook;
	}

	public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId){
		Pricebook2 standard = [
			SELECT Id, Name, IsActive
			FROM Pricebook2
			WHERE IsStandard = true
			LIMIT 1
		];

		if(!standard.isActive){
			standard.isActive = true;
			update standard;
		}

		PricebookEntry oldPricebookEntry = new PricebookEntry(
			Pricebook2Id = standard.Id,
			Product2Id = productId,
			UnitPrice = 99.00,
			IsActive = true
		);

		insert oldPricebookEntry;

		PricebookEntry newPricebookEntry = new PricebookEntry(
			Pricebook2Id = pricebookId,
			Product2Id = productId,
			UseStandardPrice = false,
			IsActive = true,
			UnitPrice = 100
		);
		insert newPricebookEntry;

		return newPricebookEntry;
	}

	public static OpportunityLineItem createOpportunityLineItem(Id pricebookEntryId, Id opportunityId){
		OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem(
			OpportunityId = opportunityId,
			PricebookEntryId = pricebookEntryId
		);

		insert newOpportunityLineItem;

		return newOpportunityLineItem;
	}
	
}