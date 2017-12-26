@isTest
public class TestDataFactory {

	public static Account createAccount(Boolean insertYN) {
		Account acc = new Account();
		acc.Name = 'Test Account';
		acc.Type = 'Customer';
		acc.BillingCountry = 'United States';
	    acc.BillingState = 'Washington';

		if(insertYN) {insert acc;}

		return acc;
	}

	public static Contact createContact(Id accID, Boolean insertYN) {
		
		Contact ctt = new Contact();
	    ctt.FirstName = 'Test';
	    ctt.LastName = 'Contact';
	    ctt.Email = 'email@mail.me';
	    ctt.MailingCountry = 'United States';
	    ctt.MailingCountryCode = 'US';
	    ctt.MailingState = 'Washington';
	    ctt.MailingStateCode = 'WA';
	    ctt.MailingPostalCode = '12345';
	    ctt.MailingStreet = '123 Main St.';
	    ctt.MailingCity = 'Seattle';
	    ctt.Phone = '404-444-4444';
	    ctt.AccountId = accID;

	    if(insertYN) {insert ctt;}

	    return ctt;
	}

	public static Opportunity createOpportunity(Id accID, Boolean insertYN) {
		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opportunity';
		opp.AccountId = accID;
		opp.StageName = 'Technical Validation';
		opp.Forecast_Status__c = 'Pipeline';
		opp.Amount = 100;
		opp.CloseDate = System.today() + 30;

		if(insertYN) {insert opp;}

		return opp;
	}

	public static OpportunityLineItem createOpportunityLineItem(Id oppID, Id pbEntryID, Decimal price, Boolean insertYN) {
		OpportunityLineItem oppLine = new OpportunityLineItem();
		oppLine.OpportunityId = oppID;
		oppLine.PricebookEntryId = pbEntryID;
		oppLine.UnitPrice = price;
		oppLine.Software_Type__c = 'Subscription';
		oppLine.Months__c = 12;


		if(insertYN) {insert oppLine;}

		return oppLine;
	}

	public static void createCompanyCode(Boolean insertYN) {
		Company_Code__c cc = new Company_Code__c();
		cc.Code__c = 'US46';
		cc.Country__c = 'US';
		cc.City__c = 'Seattle';
		cc.Currency_Picklist__c = 'USD';

		if(insertYN) {insert cc;}
	}

	public static Product2 createProduct2(Boolean insertYN) {
		Product2 prod = new Product2();
		prod.Name = 'Test Product';
		prod.IsActive = true;
		prod.ProductCode = 'PCF';
		prod.Report_Category__c = 'PaaS';
		prod.ProductCode = 'SSS-0000';

		if(insertYN) {insert prod;}

		return prod;
	}

	public static Pricebook2 createPricebook2(Boolean insertYN) {
		Pricebook2 pbk = new Pricebook2();
		pbk.Name = 'Test Pricebook';
		pbk.IsActive = true;

		if(insertYN) {insert pbk;}

		return pbk;
	}

	public static PricebookEntry createPricebookEntry(Id prodID, Decimal price, Boolean insertYN) {
		PricebookEntry pbEntry = new PricebookEntry();
		pbEntry.Product2Id = prodID;
		pbEntry.UnitPrice = price;
		pbEntry.IsActive = true;
		pbEntry.Pricebook2Id = Test.getStandardPricebookId();

		if(insertYN) {insert pbEntry;}

		return pbEntry;
	}

	public static Task createTask(Id leadId, Boolean insertYN) {
		Task taskObj = new Task();
		taskObj.whoId = leadId;
		taskObj.Subject = 'Send Email to User';
		taskObj.Status = 'New';
		taskObj.Priority = 'Normal';
		taskObj.Type = 'Phone Call';
		
		if(insertYN) {insert taskObj;}

		return taskObj;
	}

	public static Profile createProfile(String profileName) {
		return [SELECT Id FROM Profile WHERE Name = :profileName];
	}

	public static User createUser(Id profileId, Boolean insertYN) {
		User u = new User();
		u.Alias = 'standt';
		u.Email='standarduser@testorg.com';
		u.EmailEncodingKey='UTF-8';
		u.LastName='Testing';
		u.LanguageLocaleKey='en_US';
        u.LocaleSidKey='en_US';
        u.ProfileId = profileId;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.UserName='UnitTestUser' + Math.round(Math.random()*1000) + '@testorg.com';
		u.Theater__c = 'AMER';
		u.Region__c = 'Pacific NorthWest';

		if(insertYN) {insert u;}

		return u;
	}

	public static UserRole createUserRole(String userRoleName) {
		insertUserRole(userRoleName);
		return [SELECT Id, Name FROM UserRole WHERE Name = :userRoleName]; 
	}

	public static Lead createLead(Boolean insertYN) {
		Lead ld = new Lead();
		ld.Company = 'Fancy Company';
		ld.Email = 'Fancy@email.com';
		ld.FirstName = 'Lead';
		ld.LastName = 'Lady';

		if(insertYN) {insert ld;}

		return ld;
	}

	public static Country_Uplift__c createCountryUplift(String countryCode,
														Decimal productMultipler,
														Decimal serviceMultipler,
														Boolean insertYN) {
		Country_Uplift__c countryUplift = new Country_Uplift__c();
		countryUplift.name = 'Test + ' + countryCode;
		countryUplift.Country_Code__c = countryCode;
		countryUplift.Uplift_Multiplier__c = productMultipler;
		countryUplift.Service_Multiplier__c = serviceMultipler;
		if (insertYN) { insert countryUplift; }

		return countryUplift;
	}

	public static void createCategoryType(String name, String type) {
		CategoryType__c categoryType = new CategoryType__c();
		categoryType.Name = name;
		categoryType.Type__c = type;
		insert categoryType;
	}

	@future
	private static void insertUserRole(String userRoleName) {
		UserRole userRoleObj = new UserRole();
		userRoleObj.Name = userRoleName;
		insert userRoleObj;
	}

	@future
  	public static void assignUserRole(Id userId, Id roleId) {
	    User u = new User();
	    u.Id = userId;
	    u.UserRoleId = roleId;
	    update u;
	}

	public static CNS_Region__c createCNSRegion(Id userId, String Region) {
		CNS_Region__c cnsRegion = new CNS_Region__c();
		cnsRegion.Region__c = Region;
		cnsRegion.CNS_Rep__C = userId;

		insert cnsRegion;

		return cnsRegion;
	}


}