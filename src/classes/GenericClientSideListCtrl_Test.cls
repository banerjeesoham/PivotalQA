@isTest (seeAllData = false)
private class GenericClientSideListCtrl_Test {
	/*
	public GenericClientSideListCtrl_Test() {
		
	}
	*/

	private static void initTestData(){
		Lead l = new Lead(Company = 'testComp', LastName = 'TestLastName', Phone = '6049998888');
		insert l;
	}

	public static testMethod void controllerCoverage(){

		initTestData();

		List<Account> acc = [SELECT Id FROM Account];
		String jsonString = JSON.serializePretty(acc);

		GenericClientSideListCtrl tmp = new GenericClientSideListCtrl();
		tmp.controlTitle = 'test';
		tmp.columnList_p = 'Company, LastName, Phone';
		tmp.sObjectName_p = 'Account';
		tmp.queryFilter = 'Phone = \'6049998888\'';
		tmp.controlId_p = 'cId';
		tmp.showActionColumn_p  = true;
		tmp.showCheckColumn_p = true;
		tmp.queryObject();
		Test.startTest();

		GenericClientSideListCtrl.selectObject('Account', 'Phone', 'Phone = \'6049998888\'',null,null);
		GenericClientSideListCtrl.customAction('string');
		GenericClientSideListCtrl.saveObject('Account', jsonString);
		GenericClientSideListCtrl.deleteObject('Lead', String.valueOf([SELECT Id FROM Lead LIMIT 1].Id));

		Test.stopTest();

	}

	public static testMethod void queryAnyObject_Test(){
		List<sObject> resultList = new List<sObject>();
		Opportunity newOpp = trac_TestUtlity.createOpportunity();
		String query = 'SELECT Id FROM Opportunity';

		Test.startTest();
		resultList = GenericClientSideListCtrl.queryAnyObject(query);
		Test.stopTest();
	}

	public static testMethod void getNumericValue_Test(){
		Integer resultNumber;
		Opportunity newOpp = trac_TestUtlity.createOpportunity();
		String query = 'SELECT count() FROM Opportunity';

		Test.startTest();
		resultNumber = GenericClientSideListCtrl.getNumericValue(query);
		Test.stopTest();

		System.assert(resultNumber > 0);
	}

	public static testMethod void getResultStringValue_Test(){
		String resultString;
		Opportunity newOpp = trac_TestUtlity.createOpportunity();
		String query = 'SELECT Id FROM Opportunity';

		Test.startTest();
		resultString = GenericClientSideListCtrl.getStringValue(query);
		Test.stopTest();

		System.assert(resultString == '');
	}

	public static testMethod void getObjectDescribe_Test(){
		List<GenericClientSideListCtrl.ControlDescription> resultList;
		Opportunity newOpp = trac_TestUtlity.createOpportunity();

		Test.startTest();
		resultList = GenericClientSideListCtrl.getObjectDescribe('Opportunity');
		Test.stopTest();

		System.assert(!resultList.isEmpty());
	}

	public static testMethod void saveObjectWithResult_Test(){
		List<GenericClientSideListCtrl.GenericResult> resultList;
		Opportunity newOpp = trac_TestUtlity.createOpportunity();
		Opportunity retrieveOpp = [SELECT Id
								   FROM Opportunity
								   WHERE Id = :newOpp.Id];

		System.debug(JSON.serialize(retrieveOpp));

		Test.startTest();
		resultList = GenericClientSideListCtrl.saveObjectWithResult('Opportunity', '[' + JSON.serialize(retrieveOpp) + ']');
		Test.stopTest();

		System.assert(!resultList.isEmpty());
	}

	public static testMethod void saveDocument_Test(){
		Document resultDocument;
		Folder resultFolder = [SELECT Id, Name, DeveloperName, AccessType, IsReadonly, Type, NamespacePrefix, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
							   FROM Folder
							   Limit 1];

		Test.startTest();

		resultDocument = GenericClientSideListCtrl.saveDocument('Traction Document', resultFolder.Name, 'This is a test', '', '');

		Test.stopTest();
		/*
		List<Folder> resultFolder = [SELECT Id, Name, DeveloperName, AccessType, IsReadonly, Type, NamespacePrefix, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
										FROM Folder];

		for(Folder currentFolder : resultFolder){
			System.debug('::::::::::::::::::::::::::' + currentFolder.Name + '::::::::::::::::::::::::::');
		}
		*/

	}
}