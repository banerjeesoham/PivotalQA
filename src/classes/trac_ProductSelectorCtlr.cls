global with sharing class trac_ProductSelectorCtlr {
	public Id oppId {get; set;}
	public List<Pricebook2> pricebookPickList{get; set;}

	public String supJSON {get; set;}

	public trac_ProductSelectorCtlr(ApexPages.StandardController controller) {
		oppId = controller.getId();
		supJSON = '';
		querySupportProds();
	}


	private void querySupportProds() {

		Map<String, List<PricebookEntry>> mPricebookToProds = new Map<String, List<PricebookEntry>>();
		mPricebookToProds.put('All', new List<PricebookEntry>());
		for(PricebookEntry pbe : [SELECT Id, Product2.Selling_Motion__c, Product2.IsActive, Product2.Name, Pricebook2.Name 
								  FROM PricebookEntry
								  WHERE Product2.Selling_Motion__c = 'Customer Service'
								  AND Product2.IsActive = true]) {
			if(!mPricebookToProds.containsKey(pbe.Pricebook2.Name)) {
				mPricebookToProds.put(pbe.Pricebook2.Name, new List<PricebookEntry>());				
			}


			mPricebookToProds.get(pbe.Pricebook2.Name).add(pbe);
			mPricebookToProds.get('All').add(pbe);

		}

		supJSON = JSON.serializePretty(mPricebookToProds); 

	}

	@RemoteAction
	public static void saveShoppingCart(List<OpportunityLineItemWrapper> cartItems, List<String> recordsToDelete, Id oppId, String currentPricebookName){ //OpportunityLineItem
		List<OpportunityLineItem> parentsToUpsert = new List<OpportunityLineItem>();
		List<OpportunityLineItem> childsToUpsert = new List<OpportunityLineItem>();
		Savepoint selectorSavepoint;

		try{
			selectorSavepoint = Database.setSavepoint();
			deleteRecords(recordsToDelete);

			resetPricebook(oppId, currentPricebookName);
			
			for(OpportunityLineItemWrapper currentWrappedItem : cartItems){
				parentsToUpsert.add(currentWrappedItem.getBaseOLI());
			}

			upsert parentsToUpsert;

			for(OpportunityLineItemWrapper currentWrappedChildItem : cartItems){
				if(currentWrappedChildItem.childOLIWrapper != null){
					childsToUpsert.add(currentWrappedChildItem.getSupportOLI());
				}
			}

			upsert childsToUpsert;

			} catch(Exception ex){
				Database.rollback(selectorSavepoint);
				if((ex.getMessage()).contains('INVALID_CROSS_REFERENCE_KEY')){
					throw new SelectorException('Products from different pricebook were found in the selection.');
				}else{
					throw new SelectorException(ex.getMessage());
				}
			}

	}

	@RemoteAction
	public static List<String> loadPricebookPicklistValues(){
		Set<String> pricebookValues = new Set<String>();
		List<PricebookEntry> pricebookEntryResults;
		List<String> pricebookPicklist;
		
		pricebookEntryResults = [
			SELECT Pricebook2.Name
			FROM PricebookEntry
		];
		
		for(PricebookEntry entry : pricebookEntryResults){
			pricebookValues.add(entry.Pricebook2.Name);
		}
		
		pricebookPicklist = new List<String>(pricebookValues);
		pricebookPicklist.sort();

		return pricebookPicklist;
	}

	@RemoteAction
	public static List<String> loadSellingMotionPicklistValues(String pricebookName){
		Set<String> sellingMotionValues = new Set<String>();
		List<PricebookEntry> sellingMotionResults;
		List<String> sellingMotionPicklist;
		
		sellingMotionResults = [
			SELECT Product2.Selling_Motion__c
			FROM PricebookEntry
			WHERE Pricebook2.Name = :pricebookName
		];
		
		for(PricebookEntry entry : sellingMotionResults){
			sellingMotionValues.add(entry.Product2.Selling_Motion__c);
		}
		
		sellingMotionPicklist = new List<String>(sellingMotionValues);
		sellingMotionPicklist.sort();

		return sellingMotionPicklist;
	}

	@RemoteAction
	public static List<String> loadProductFamilyPicklistValues(String pricebookName, String sellingMotionName){
		Set<String> productFamilyValues = new Set<String>();
		List<PricebookEntry> productFamilyResults;
		List<String> productFamilyPicklist;
		
		productFamilyResults = [
			SELECT Product2.Family
			FROM PricebookEntry
			WHERE Pricebook2.Name = :pricebookName AND Product2.Selling_Motion__c = :sellingMotionName AND Product2.Family <> 'Customer Service'
		];
		
		for(PricebookEntry entry : productFamilyResults){
			productFamilyValues.add(entry.Product2.Family);
		}

		productFamilyPicklist = new List<String>(productFamilyValues);
		productFamilyPicklist.sort();
		
		return productFamilyPicklist;
	}

	@RemoteAction
	public static List<String> loadProductYearPicklistValues(String pricebookName, String sellingMotionName, String productFamilyName){
		Set<String> productYearValues = new Set<String>();
		List<PricebookEntry> productYearResults;
		List<String> productYearPicklist;
		
		productYearResults = [
			SELECT Product2.Year__c
			FROM PricebookEntry
			WHERE Pricebook2.Name = :pricebookName AND Product2.Selling_Motion__c = :sellingMotionName AND Product2.Family = :productFamilyName
		];

		for(PricebookEntry entry : productYearResults){
			productYearValues.add(entry.Product2.Year__c);
		}

		productYearPicklist = new List<String>(productYearValues);
		productYearPicklist.sort();
		
		return productYearPicklist;
	}

	public static void deleteRecords(List<String> recordsToDelete){
		List<OpportunityLineItem> oppLineItemToDelete;

		try{
			oppLineItemToDelete = [
				SELECT Id
				FROM OpportunityLineItem
				WHERE Id IN :recordsToDelete
			];

			delete oppLineItemToDelete;
		} catch(Exception ex){
			System.debug('deleteRecords Method Exception Message: ' + ex.getMessage());
		}
	}

	public static void resetPricebook(Id currentOpportunityId, String currentPricebookName){
		Opportunity currentOpportunity;
		currentOpportunity = [
		  SELECT Id, Name, Pricebook2Id, Pricebook2.Name
		  FROM Opportunity
		  WHERE Id = :currentOpportunityId
		];

		if(currentPricebookName != null){
			if(currentOpportunity.Pricebook2.Name != currentPricebookName){
				currentOpportunity.Pricebook2Id = null;
			}

			update currentOpportunity;
		}
	}

	@RemoteAction
	public static String lockPricebookFilter(Id currentOpportunityId){
		List<Opportunity> currentOpportunity = [
			SELECT Pricebook2.Name
			FROM Opportunity
			WHERE Id = :currentOpportunityId
			AND Pricebook2.Name NOT IN ('Standard Price Book', 'Legacy Product')
		];

		if(!(currentOpportunity.isEmpty())){
			return currentOpportunity[0].Pricebook2.Name;
		} else{
			return null;
		}

	}

	/*
	 * @description Allows any line items that have support
	 */
	public class OpportunityLineItemWrapper {

		public OpportunityLineItem oli {get; set;}
		public OpportunityLineItemWrapper childOLIWrapper {get; set;}

		public OpportunityLineItemWrapper(OpportunityLineItem oli){
			this.oli = oli;
		}

		public OpportunityLineItemWrapper(OpportunityLineItem oli, OpportunityLineItemWrapper childOLIWrapper) {
			this.oli = oli;
			this.childOLIWrapper = childOLIWrapper;
		}

		public OpportunityLineItem getBaseOLI() {
			return oli;
		}

		public OpportunityLineItem getSupportOLI() {
			// should have id
			childOLIWrapper.oli.OLI_Id__c = oli.Id;
			return childOLIWrapper.oli;
		}
	}

	public class SelectorException extends Exception{

	}

}