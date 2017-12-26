@isTest
public class NewQuotePageControllerTest {
        

        @isTest 
        static void testContactUpdateTrigger() {
                // Implement test code
                Account acct = ZTestFactory.makeAccount(); 
                Contact contact = ZTestFactory.makeContact(acct);

                contact.FirstName = 'Test';
                update contact;
        }

        @isTest 
        static void invokeNewQuotePropertyComponent() {
                // Implement test code
                Account acct = ZTestFactory.makeAccount(); 
                Contact contact = ZTestFactory.makeContact(acct);
                Opportunity opp = ZTestFactory.makeOpportunity(acct);
                ZTestFactory.makeZuoraCustomSetting();

                PageReference pageRef = Page.NewQuotePage;
                pageRef.setRedirect(true);
                pageRef.getParameters().put('billingAccountId', 'dasgadgkjbn23lkj245');
                pageRef.getParameters().put('crmAccountId', acct.Id);
                pageRef.getParameters().put('oppId', opp.Id);
                pageRef.getParameters().put('quoteType', 'Subscription');
                pageRef.getParameters().put('editMode', 'false');
                Test.setCurrentPage(pageRef);

                ApexPages.StandardController con = new ApexPages.StandardController(opp);

                NewQuotePageController propComponent = new NewQuotePageController(con);
                Opportunity compOpp = propComponent.opp;
                Account compAcct = propComponent.acct;

                NewQuotePageController.DefaultValuesPlugin dvp = new NewQuotePageController.DefaultValuesPlugin();
                dvp.populateDefaultFieldValue((SObject)propComponent.quote, propComponent);
                propComponent.quote.zqu__BillToContact__c = contact.Id;
                List<SelectOption> paymentplanvalues = propComponent.paymentPlanValues;
                List<SelectOption> billingMethodValues = propComponent.billingMethodValues;
                List<SelectOption> companyCodeValues = propComponent.companyCodeValues;
                String selectedPaymentMethod = propComponent.selectedPaymentMethod;
                String originalSelectedContact = propComponent.originalSelectedContact;

                NewQuotePageController.PopulateRelatedObjectFieldPlugin prop = new NewQuotePageController.PopulateRelatedObjectFieldPlugin();
                prop.getRelatedObject(propComponent.propertyOptions.parentController);
                //propComponent.propertyOptions.populateValuePlugin.populateDefaultFieldValue((SObject)propComponent.quote, propComponent.propertyOptions.parentController);
                //propComponent.propertyOptions.PopulateRelatedObjectFieldPlugin.getRelatedObject(con);

                propComponent.selectedContact = contact.Id+',null,null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+',null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+','+contact.Id;
                propComponent.onContactChange();

                propComponent.paymentPlanChange();
                propComponent.billingMethodChange();
                propComponent.quote.Same_As_Bill_To_Contact__c = true;
                propComponent.contactCheckBoxChange();
                propComponent.quote.Same_As_Bill_To_Contact__c = false;
                propComponent.contactCheckBoxChange();
                propComponent.shippingCheckBoxChange();
                propComponent.currencyChange();
                propComponent.channelChange();
                NewQuotePageController.SaveRecordPlugin savePlugin = new NewQuotePageController.SaveRecordPlugin();
                savePlugin.doUpdate((SObject)propComponent.quote, propComponent);

                propComponent.stayOnCurrentPage();
                propComponent.continueToNextPage();

                propComponent.originalSelectedContact = 'contact1,contact2';
                propComponent.loadOriginalContacts();

        }

        @isTest 
        static void invokeNewAmendmentQuotePropertyComponent() {
                // Get test account, contact and opp
                Account acct = ZTestFactory.makeAccount(); 
                Contact contact = ZTestFactory.makeContact(acct);
                Opportunity opp = ZTestFactory.makeOpportunity(acct);
                ZTestFactory.makeZuoraCustomSetting();

                // Set up page parameters
                PageReference pageRef = Page.NewQuotePage;
                pageRef.setRedirect(true);
                pageRef.getParameters().put('billingAccountId', 'dasgadgkjbn23lkj245');
                pageRef.getParameters().put('crmAccountId', acct.Id);
                pageRef.getParameters().put('oppId', opp.Id);
                pageRef.getParameters().put('quoteType', 'Amendment');
                pageRef.getParameters().put('editMode', 'false');
                Test.setCurrentPage(pageRef);

                ApexPages.StandardController con = new ApexPages.StandardController(opp);
                NewQuotePageController propComponent = new NewQuotePageController(con);
                Opportunity compOpp = propComponent.opp;
                propComponent.opp.Name = opp.Name;
                Account compAcct = propComponent.acct;

                NewQuotePageController.DefaultValuesPlugin dvp = new NewQuotePageController.DefaultValuesPlugin();
                dvp.populateDefaultFieldValue((SObject)propComponent.quote, propComponent);
                propComponent.quote.zqu__BillToContact__c = contact.Id;
                List<SelectOption> paymentplanvalues = propComponent.paymentPlanValues;
                List<SelectOption> billingMethodValues = propComponent.billingMethodValues;

                NewQuotePageController.PopulateRelatedObjectFieldPlugin prop = new NewQuotePageController.PopulateRelatedObjectFieldPlugin();
                prop.getRelatedObject(propComponent.propertyOptions.parentController);
                //propComponent.propertyOptions.populateValuePlugin.populateDefaultFieldValue((SObject)propComponent.quote, propComponent.propertyOptions.parentController);
                //propComponent.propertyOptions.PopulateRelatedObjectFieldPlugin.getRelatedObject(con);

                propComponent.selectedContact = contact.Id+',null,null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+',null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+','+contact.Id;
                propComponent.onContactChange();

                propComponent.paymentPlanChange();
                propComponent.billingMethodChange();
                propComponent.quote.Same_As_Bill_To_Contact__c = true;
                propComponent.contactCheckBoxChange();
                propComponent.quote.Same_As_Bill_To_Contact__c = false;
                propComponent.contactCheckBoxChange();
                propComponent.shippingCheckBoxChange();
                propComponent.currencyChange();
                NewQuotePageController.CancelRecordPlugin cancelPlugin = new NewQuotePageController.CancelRecordPlugin();
                cancelPlugin.doCancel((SObject)propComponent.quote, propComponent);
        }

        @isTest 
        static void invokeEditQuotePropertyComponent() {
                // Implement test code
                Account acct = ZTestFactory.makeAccount();
                Contact contact = ZTestFactory.makeContact(acct);
                Opportunity opp = ZTestFactory.makeOpportunity(acct);
                ZTestFactory.makeZuoraCustomSetting();
                ZTestFactory.makeCompanyCode(true);

                zqu__Quote__c zquote = ZTestFactory.makeQuote(opp, contact);
                zquote.zqu__ZuoraAccountID__c = 'dasgadgkjbn23lkj245';
                zquote.Company_Code1__c = 'US46';
                zquote.Ship_To_First_Name__c = 'asgfadg';
                zquote.Ship_To_Last_Name__c = 'asgfadg';
                zquote.Ship_Contact_Email__c = 'email@mail.me';
                update zquote;

                PageReference pageRef = Page.NewQuotePage;
                pageRef.setRedirect(true);
                //pageRef.getParameters().put('billingAccountId', 'dasgadgkjbn23lkj245');
                pageRef.getParameters().put('crmAccountId', acct.Id);
                pageRef.getParameters().put('oppId', opp.Id);
                pageRef.getParameters().put('quoteType', 'Subscription');
                pageRef.getParameters().put('editMode', 'true');
                pageRef.getParameters().put('quoteId', zquote.Id);
                Test.setCurrentPage(pageRef);

                ApexPages.StandardController con = new ApexPages.StandardController(opp);

                NewQuotePageController propComponent = new NewQuotePageController(con);
                Opportunity compOpp = propComponent.opp;
                Account compAcct = propComponent.acct;
                System.debug('zuora account id in testing: '+ propComponent.quote.zqu__ZuoraAccountID__c);

                //NewQuotePageController.DefaultValuesPlugin dvp = new NewQuotePageController.DefaultValuesPlugin();
                //dvp.populateDefaultFieldValue((SObject)zquote, propComponent);

                //NewQuotePageController.PopulateRelatedObjectFieldPlugin prop = new NewQuotePageController.PopulateRelatedObjectFieldPlugin();
                //prop.getRelatedObject(propComponent.propertyOptions.parentController);
                //propComponent.selectedContact = contact.Id+','+contact.Id;
                //propComponent.onContactChange();
                // Contact change
                propComponent.selectedContact = contact.Id+',null,null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+',null';
                propComponent.onContactChange();

                propComponent.selectedContact = contact.Id+','+contact.Id+','+contact.Id;
                propComponent.onContactChange();
                // Tax exempt change
                propComponent.onTaxExemptChange();
                // Payment plan change
                propComponent.paymentPlanChange();
                // Billing method change
                propComponent.billingMethodChange();
                // Toggle contact check box
                propComponent.quote.Same_As_Bill_To_Contact__c = true;
                propComponent.contactCheckBoxChange();
                propComponent.quote.Same_As_Bill_To_Contact__c = false;
                propComponent.contactCheckBoxChange();
                // Shipping checkbox change
                propComponent.shippingCheckBoxChange();
                // Currency change
                propComponent.currencyChange();
                propComponent.companyCodeChange();
                //propComponent.propertyOptions.populateValuePlugin.populateDefaultFieldValue((SObject)propComponent.quote, propComponent.propertyOptions.parentController);
                //propComponent.propertyOptions.PopulateRelatedObjectFieldPlugin.getRelatedObject(con);

                NewQuotePageController.DefaultValuesPlugin dvp = new NewQuotePageController.DefaultValuesPlugin();
                dvp.populateDefaultFieldValue((SObject)zquote, propComponent);

                NewQuotePageController.PopulateRelatedObjectFieldPlugin prop = new NewQuotePageController.PopulateRelatedObjectFieldPlugin();
                prop.getRelatedObject(propComponent);

                NewQuotePageController.SaveRecordPlugin savePlugin = new NewQuotePageController.SaveRecordPlugin();
                savePlugin.doUpdate((SObject)propComponent.quote, propComponent);

        }       
        

        public static List < Zuora.zObject > createDummySubList() {
                List < Zuora.zObject > returnValue = new List < Zuora.zObject >();
                Zuora.zObject subzobj = new Zuora.zObject('Subscription');
                Datetime currDate = datetime.valueOf('2015-06-08 02:00:00');
                subzobj.setValue('Name', 'test Name');
                subzobj.setValue('Version', 1);
                subzobj.setValue('AccountId', '3k2h5j2l3k4j523l4k5jh23');
                subzobj.setValue('Subscription_Type__c', 'Product');
                subzobj.setValue('Payment_Plan__c', 'Annual');
                subzobj.setValue('OriginalId', '3k2h5j2l3k4j523l4k5jh23');
                subzobj.setValue('ContractEffectiveDate', currDate);
                subzobj.setValue('AutoRenew', true);
                subzobj.setValue('InitialTerm', 12);
                subzobj.setValue('TermStartDate', currDate);
                subzobj.setValue('TermEndDate', currDate);
                subzobj.setValue('TermType', 'TERMED');
                subzobj.setValue('RenewalTerm', 12);
                returnValue.add(subzobj);
                return returnValue;
        }

        public static Contact createContact(String accId) {
                Account acct = new Account(); 
                acct.Id = accId; 
                Contact contact = ZTestFactory.makeContact(acct); 
                return contact; 
        }

        public static List < Zuora.zObject > createDummyAcctList() {
                List < Zuora.zObject > returnValue = new List < Zuora.zObject >();
                Zuora.zObject acctzobj = new Zuora.zObject('Account');
                acctzobj.setValue('BillToId', '3k2h5j2l3k4j523l4k5jh23');
                acctzobj.setValue('SoldToId', '3k2h5j2l3k4j523l4k5jh23');
                acctzobj.setValue('Currency', 'USD');
                acctzobj.setValue('PaymentTerm', 'Net 30');
                acctzobj.setValue('Channel__c', 'Pivotal Direct');
                acctzobj.setValue('Company_Code__c', 'US46');
                acctzobj.setValue('InvoiceDeliveryPrefsEmail', true);
                acctzobj.setValue('InvoiceDeliveryPrefsPrint', true);
                acctzobj.setValue('CRM_Sold_To_Contact_Id__c', 'TestCont'); 
                acctzobj.setValue('CRM_Bill_To_Contact_Id__c', 'TestCont'); 
                returnValue.add(acctzobj);
                return returnValue;
        }

        public static List < Zuora.zObject > createDummyCntctList() {
                List < Zuora.zObject > returnValue = new List < Zuora.zObject >();
                Zuora.zObject acctzobj = new Zuora.zObject('Contact');
                acctzobj.setValue('Address1', '123 Main St.');
                acctzobj.setValue('City', 'Palo Alto');
                acctzobj.setValue('Country', 'US');
                acctzobj.setValue('PostalCode', '58293');
                acctzobj.setValue('State', 'CA');
                acctzobj.setValue('FirstName', 'GE');
                acctzobj.setValue('LastName', 'Direct');
                returnValue.add(acctzobj);
                return returnValue;
        }
}