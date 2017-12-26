@isTest(SeeAllData=true)
private class trac_ProductSelectorCtlr_SeeAllData_Test {
	/*
	 * @description Creates a new trac_ProductSelectorCtlr object, and test
	 *              that the initial values are set when the object is created.
	 *
	 * @author Thomas Tran - Traction on Demand
	 *
	 * @date July 29, 2014
	 */
	static testmethod void test_constructor(){
		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		ApexPages.StandardController opportunityStandard = new ApexPages.StandardController(newOpportunity);

		Test.startTest();

		trac_ProductSelectorCtlr productSelector = new trac_ProductSelectorCtlr(opportunityStandard);

		Test.stopTest();

		System.assertEquals(newOpportunity.Id, productSelector.oppId);
		System.assertNotEquals('', productSelector.supJSON);
	}

	/*
	 * @description Retrieves all the pricebook names for the picklist on the
	 *              page to query by.
	 *
	 * @author Thomas Tran - Traction on Demand
	 *
	 * @date July 29, 2014
	 */
	static testmethod void test_loadPricebookPickListValues(){
		List<String> pricebookPicklistValues = new List<String>();

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		ApexPages.StandardController opportunityStandard = new ApexPages.StandardController(newOpportunity);

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();

		Test.stopTest();

		System.assert(!pricebookPicklistValues.isEmpty());
	}

	static testmethod void test_loadSellingMotionPicklistValues(){
		List<String> pricebookPicklistValues = new List<String>();
		List<String> sellingMotionPicklistValues = new List<String>();

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		ApexPages.StandardController opportunityStandard = new ApexPages.StandardController(newOpportunity);

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();
		sellingMotionPicklistValues = trac_ProductSelectorCtlr.loadSellingMotionPicklistValues(pricebookPicklistValues[0]);

		Test.stopTest();

		System.assert(!pricebookPicklistValues.isEmpty());
	}

	static testmethod void test_loadProductFamilyPicklistValues(){
		List<String> pricebookPicklistValues = new List<String>();
		List<String> sellingMotionPicklistValues = new List<String>();
		List<String> productFamilyPicklistValues = new List<String>();

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		ApexPages.StandardController opportunityStandard = new ApexPages.StandardController(newOpportunity);

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();
		sellingMotionPicklistValues = trac_ProductSelectorCtlr.loadSellingMotionPicklistValues(pricebookPicklistValues[0]);
		productFamilyPicklistValues = trac_ProductSelectorCtlr.loadProductFamilyPicklistValues(pricebookPicklistValues[0], sellingMotionPicklistValues[0]);

		Test.stopTest();

		System.assert(!productFamilyPicklistValues.isEmpty());
	}

	static testmethod void test_loadProductYearPicklistValues(){
		List<String> pricebookPicklistValues = new List<String>();
		List<String> sellingMotionPicklistValues = new List<String>();
		List<String> productFamilyPicklistValues = new List<String>();
		List<String> productYearPicklistValues = new List<String>();

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		ApexPages.StandardController opportunityStandard = new ApexPages.StandardController(newOpportunity);

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();
		sellingMotionPicklistValues = trac_ProductSelectorCtlr.loadSellingMotionPicklistValues(pricebookPicklistValues[0]);
		productFamilyPicklistValues = trac_ProductSelectorCtlr.loadProductFamilyPicklistValues(pricebookPicklistValues[0], sellingMotionPicklistValues[0]);
		productYearPicklistValues = trac_ProductSelectorCtlr.loadProductYearPicklistValues(pricebookPicklistValues[0], sellingMotionPicklistValues[0], productFamilyPicklistValues[0]);

		Test.stopTest();

		System.assert(!productYearPicklistValues.isEmpty());
	}

	static testmethod void test_resetPricebook(){
		List<String> pricebookPicklistValues = new List<String>();

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		newOpportunity.Pricebook2Id = newPricebook.Id;

		update newOpportunity;

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();
		trac_ProductSelectorCtlr.resetPricebook(newOpportunity.Id, pricebookPicklistValues[0]);

		Test.stopTest();

	}

	static testmethod void test_lockPricebookFilter(){
		List<String> pricebookPicklistValues = new List<String>();
		String result;

		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		newOpportunity.Pricebook2Id = newPricebook.Id;

		update newOpportunity;

		Test.startTest();

		pricebookPicklistValues = trac_ProductSelectorCtlr.loadPricebookPicklistValues();
		result = trac_ProductSelectorCtlr.lockPricebookFilter(newOpportunity.Id);

		Test.stopTest();

		System.assertEquals('Traction Pricebook', result);
	}

	static testmethod void test_deleteRecords(){
		List<String> pricebookPicklistValues = new List<String>();
		List<Id> idsToDeleteList = new List<Id>();
		String result;

		OpportunityLineItem newOpportunityLineItem;
		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);

		newOpportunity.Pricebook2Id = newPricebook.Id;

		update newOpportunity;

		newOpportunityLineItem = trac_TestUtlity.createOpportunityLineItem(newPricebookEntry.Id, newOpportunity.Id);

		pricebookPicklistValues.add(newOpportunityLineItem.Id);

		Test.startTest();

		trac_ProductSelectorCtlr.deleteRecords(pricebookPicklistValues);

		Test.stopTest();
	}

	static testmethod void test_OpportunityLineItemWrapper(){
		String result;

		OpportunityLineItem newOpportunityLineItem;
		OpportunityLineItem newOpportunityLineItem2;
		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Opportunity newOpportunity2 = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Pricebook2 newPricebook2 = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		Product2 newProduct2 = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);
		PricebookEntry newPricebookEntry2 = trac_TestUtlity.createPricebookEntry(newPricebook2.Id, newProduct2.Id);

		newOpportunity.Pricebook2Id = newPricebook.Id;

		update newOpportunity;

		newOpportunityLineItem = trac_TestUtlity.createOpportunityLineItem(newPricebookEntry.Id, newOpportunity.Id);
		newOpportunityLineItem2 = trac_TestUtlity.createOpportunityLineItem(newPricebookEntry2.Id, newOpportunity2.Id);

		trac_ProductSelectorCtlr.OpportunityLineItemWrapper oliWrapper = new trac_ProductSelectorCtlr.OpportunityLineItemWrapper(newOpportunityLineItem);
		trac_ProductSelectorCtlr.OpportunityLineItemWrapper oliWrapper2 = new trac_ProductSelectorCtlr.OpportunityLineItemWrapper(newOpportunityLineItem2, oliWrapper);

		System.assertEquals(newOpportunityLineItem.Id, oliWrapper2.getSupportOLI().Id);
		System.assertEquals(newOpportunityLineItem2.Id, oliWrapper2.getBaseOLI().Id);
		System.assertEquals(newOpportunityLineItem.Id, oliWrapper.getBaseOLI().Id);
	}

	static testmethod void test_saveShoppingCart(){
		List<trac_ProductSelectorCtlr.OpportunityLineItemWrapper> testOLIW = new List<trac_ProductSelectorCtlr.OpportunityLineItemWrapper>();
		List<String> idsToDeleteList = new List<String>();
		OpportunityLineItem newOpportunityLineItem;
		OpportunityLineItem newOpportunityLineItem2;
		Opportunity newOpportunity = trac_TestUtlity.createOpportunity();
		Opportunity newOpportunity2 = trac_TestUtlity.createOpportunity();
		Pricebook2 newPricebook = trac_TestUtlity.createPricebook();
		Pricebook2 newPricebook2 = trac_TestUtlity.createPricebook();
		Product2 newProduct = trac_TestUtlity.createProduct();
		Product2 newProduct2 = trac_TestUtlity.createProduct();
		PricebookEntry newPricebookEntry = trac_TestUtlity.createPricebookEntry(newPricebook.Id, newProduct.Id);
		PricebookEntry newPricebookEntry2 = trac_TestUtlity.createPricebookEntry(newPricebook2.Id, newProduct2.Id);

		newOpportunity.Pricebook2Id = newPricebook.Id;

		update newOpportunity;

		newOpportunityLineItem = trac_TestUtlity.createOpportunityLineItem(newPricebookEntry.Id, newOpportunity.Id);
		newOpportunityLineItem2 = trac_TestUtlity.createOpportunityLineItem(newPricebookEntry2.Id, newOpportunity2.Id);

		trac_ProductSelectorCtlr.OpportunityLineItemWrapper oliWrapper = new trac_ProductSelectorCtlr.OpportunityLineItemWrapper(newOpportunityLineItem);
		trac_ProductSelectorCtlr.OpportunityLineItemWrapper oliWrapper2 = new trac_ProductSelectorCtlr.OpportunityLineItemWrapper(newOpportunityLineItem2, oliWrapper);

		testOLIW.add(oliWrapper);
		testOLIW.add(oliWrapper2);

		Test.startTest();

		trac_ProductSelectorCtlr.saveShoppingCart(testOLIW, idsToDeleteList, newOpportunity2.Id, newPricebook2.Name);

		Test.stopTest();
	}
	
}