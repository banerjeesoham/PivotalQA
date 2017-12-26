public with sharing class ZQuoteTriggerHandler extends TriggerHandler {
    public ZQuoteTriggerHandler() {}

    /* Context Overrides */

    protected override void beforeUpdate(){
        updateValidUntilField();
        updateRelatedOpportunityWhenBooked();
    }

    protected override void afterInsert(){
        updateRelatedOpportunityHasQuote();
    }

    /* Private Methods */

    private void updateValidUntilField() {
        Map<Id, zqu__Quote__c> oldMap = (Map<Id, zqu__Quote__c>)Trigger.oldMap;

        for(zqu__Quote__c quote : (List<zqu__Quote__c>)Trigger.new) {
            if(quote.zqu__StartDate__c != oldMap.get(quote.Id).zqu__StartDate__c) {
                Period quarterPeriod = [SELECT EndDate FROM Period WHERE StartDate <= :quote.zqu__StartDate__c AND EndDate >= :quote.zqu__StartDate__c AND Type = 'Quarter'];
                quote.zqu__ValidUntil__c = quarterPeriod.EndDate;
            }
        }
    }

    private void updateRelatedOpportunityHasQuote() {
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id, zqu__Quote__c> quoteMap = new Map<Id, zqu__Quote__c>([SELECT Id, zqu__Opportunity__r.Id
                                                                      FROM zqu__Quote__c
                                                                      WHERE zqu__Quote__c.Id = :Trigger.newMap.keySet()]);

        for(zqu__Quote__c quote : quoteMap.values()) {
            Opportunity opp = new Opportunity(Id = quote.zqu__Opportunity__r.Id);
            opp.HasQuote__c = true;
            oppList.add(opp);
        }

        update oppList;
    }


    private void updateRelatedOpportunityWhenBooked() {
        Map<Id, Opportunity> oppsToBook = new Map<Id, Opportunity>();
        Map<Id, zqu__Quote__c> savedQuotes = new Map<Id, zqu__Quote__c>();
        Map<Id, zqu__Quote__c> quoteMap = new Map<Id, zqu__Quote__c>([SELECT Id, zqu__Opportunity__r.Id, zqu__Opportunity__r.Booked__c
                                                                      FROM zqu__Quote__c
                                                                      WHERE zqu__Quote__c.Id = :Trigger.newMap.keySet()]);

        for(zqu__Quote__c quote : (List<zqu__Quote__c>)Trigger.new) {
            if (quote.Primary_Quote__c == true && quote.Fulfilled__c == false && quoteMap.get(quote.Id).zqu__Opportunity__r.Booked__c == false && quote.zqu__Status__c.equals('Sent to Z-Billing')){
                updateQuoteDetails(quote);

                savedQuotes.put(quote.Id, quoteMap.get(quote.Id));

                Id oppId = quoteMap.get(quote.Id).zqu__Opportunity__r.Id;
                Opportunity opp = generateBookedOpp(oppId, quote);
                oppsToBook.put(opp.Id, opp);
            }
        }

        if(oppsToBook.size() > 0) {
            deleteOldOppLineItems(oppsToBook.keySet());

            update oppsToBook.values();

            generateAndInsertOppLineItems(savedQuotes);

            generateAndInsertRenewalOpps(oppsToBook.keySet());
        }
    }

    private String determineCoreOrderProcessor(String channel){
        if (channel.contains('EMC')){
            return 'EMC';
        } else if (channel.contains('VMW')) {
            return 'VMW';
        } else {
            return 'Pivotal';
        }
    }

    private void deleteOldOppLineItems(Set<Id> oppIds) {
        List<OpportunityLineItem> oppLineItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :oppIds];
        if(oppLineItems.size() > 0) {
            delete oppLineItems;
        }
    }

    private Opportunity generateBookedOpp(Id oppId, zqu__Quote__c quote) {
        Opportunity opp = new Opportunity(Id = oppId);
        opp.Booked__c = true;
        opp.CloseDate = System.today();
        opp.Core_Order_Processed__c = determineCoreOrderProcessor(quote.Channel__c);
        opp.Forecast_Status__c = 'Closed';
        opp.Forecast__c = true;
        opp.Probability = 100;
        opp.RecordTypeID = '012U0000000XX3jIAG';
        opp.Sales_Order_Number__c = quote.ChannelOrderId__c;
        opp.Sold_To_Country__c = quote.Sold_To_Country__c;
        opp.StageName = 'Booked';
        opp.Type = quote.zqu__SubscriptionType__c;
        opp.CurrencyIsoCode = quote.zqu__Currency__c;

        return opp;
    }

    private void generateAndInsertOppLineItems(Map<Id, zqu__Quote__c> savedQuotes) {
        List<zqu__QuoteRatePlanCharge__c> quoteRatePlanCharges = queryQuoteRatePlanCharges(savedQuotes.keySet());
        List<String> productSkuList = new List<String>();

        for(zqu__QuoteRatePlanCharge__c qrpc : quoteRatePlanCharges) {
            productSkuList.add(qrpc.Booking_SKU__c);
        }

        if(productSkuList.size() > 0) {
            List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
            List<PricebookEntry> pricebookEntries = [SELECT Id, Pricebook2Id, Product2Id, CurrencyIsoCode, ProductCode FROM PricebookEntry WHERE Pricebook2Id = '01sU0000000qiVy' AND IsActive = true AND ProductCode IN :productSkuList];

            for (PricebookEntry pbe : pricebookEntries) {
                for (zqu__QuoteRatePlanCharge__c qrpc : quoteRatePlanCharges) {
                    if (qrpc.zqu__Currency__c == pbe.CurrencyIsoCode && qrpc.Booking_SKU__c == pbe.ProductCode) {
                        OpportunityLineItem oppLine = new OpportunityLineItem();
                        oppLine.PricebookEntryId = pbe.Id;
                        oppLine.OpportunityId = savedQuotes.get(qrpc.zqu__QuoteRatePlan__r.zqu__Quote__r.Id).zqu__Opportunity__r.Id;
                        oppLine.Accounting_Code__c = qrpc.Accounting_Code__c;
                        oppLine.Billing_Period__c = qrpc.Billing_Period__c;
                        oppLine.Booking_Discount__c = qrpc.ApproveDiscount__c;
                        oppLine.Booking_Quantity__c = qrpc.zqu__Quantity__c;
                        oppLine.End_User_Price__c = qrpc.Indirect_Price_Total__c;
                        oppLine.Indirect_Price_Total__c = qrpc.Indirect_Price_Total__c;
                        oppLine.Initial_Term__c = qrpc.Initial_Term__c;
                        oppLine.ListedPrice__c = qrpc.zqu__ListPrice__c;
                        oppLine.Quantity = 1;
                        oppLine.Software_Type__c = qrpc.Booking_Software_Type__c;
                        oppLine.StartDate__c = date.valueOf(qrpc.Start_Date__c);
                        oppLine.UnitPrice = qrpc.Indirect_Price_Total__c;
                        oppLine.Unit_of_Measure__c = qrpc.zqu__UOM__c;
                        oppLine.Years__c = qrpc.Booking_Years__c;
                        oppLine.Months__c = qrpc.Booking_Months__c;
                        oppLine.ZuoraTCV__c = qrpc.Indirect_Price_Total__c;
                        oppLine.Zuora_Price__c = qrpc.Indirect_Price_Total__c;

                        if(qrpc.End_Date__c != null) {
                            oppLine.EndDate__c = date.valueOf(qrpc.End_Date__c) - 1;
                        }

                        oppLineItems.add(oppLine);
                    }
                }
            }

            if (oppLineItems.size() > 0) {
                insert oppLineItems;
            }
        }
    }

    private List<zqu__QuoteRatePlanCharge__c> queryQuoteRatePlanCharges(Set<Id> quoteIds) {
        return [SELECT Id,
                        zqu__Currency__c,
                        Booking_SKU__c,
                        Accounting_Code__c,
                        Billing_Period__c,
                        ApproveDiscount__c,
                        zqu__Quantity__c,
                        End_Date__c,
                        Indirect_Price_Total__c,
                        Initial_Term__c,
                        zqu__ListPrice__c,
                        Booking_Software_Type__c,
                        Start_Date__c,
                        zqu__UOM__c,
                        Booking_Years__c,
                        Booking_Months__c,
                        zqu__QuoteRatePlan__r.zqu__Quote__r.Id
                FROM zqu__QuoteRatePlanCharge__c
                WHERE zqu__QuoteRatePlan__r.zqu__Quote__r.Id = :quoteIds];
    }

    private void generateAndInsertRenewalOpps(Set<Id> oppIds) {
        List<Opportunity> renewalOpportunities = new List<Opportunity>();
        List<OpportunityLineItem> renewalOppLineItems = new List<OpportunityLineItem>();

        List<Opportunity> opportunities = [SELECT Id,
                                                    Name,
                                                    AccountId,
                                                    OwnerId,
                                                    Core_Order_Processed__c,
                                                    CloseDate,
                                                    Forecast__c,
                                                    RecordTypeID,
                                                    Opportunity_Number__c,
                                                    CurrencyIsoCode,
                                                    Opportunity_Channel__c,
                                                    (SELECT Id,
                                                            ListPrice,
                                                            Product2Id,
                                                            PriceBookEntryId,
                                                            ProductCode,
                                                            Quantity,
                                                            UnitPrice,
                                                            Software_Type__c,
                                                            Years__c,
                                                            Months__c,
                                                            EndDate__c
                                                    FROM OpportunityLineItems
                                                    WHERE Software_Type__c != 'Perpetual' AND Software_Type__c != null)
                                            FROM Opportunity
                                            WHERE Id IN :oppIds];

        for(Opportunity opp : opportunities) {
            if(opp.OpportunityLineItems.size() > 0) {
                Opportunity renewalOpp = opp.clone(false, true, false, false);
                renewalOpp.AccountId = opp.AccountId;
                renewalOpp.StageName = 'Business Validation';
                renewalOpp.Forecast_Status__c = 'Commit';
                renewalOpp.Probability = 50;
                renewalOpp.Type = 'Renew Subscription';
                renewalOpp.CloseDate = determineRenewalCloseDate(opp.OpportunityLineItems);
                renewalOpp.RecordTypeId = '012U0000000XX3eIAG';
                renewalOpp.Name = opp.Opportunity_Number__c + '--Renewal';

                renewalOpportunities.add(renewalOpp);
            }
        }

        if(renewalOpportunities.size() > 0) {
            insert renewalOpportunities;

            for(Opportunity opp : renewalOpportunities) {
                for(OpportunityLineItem oli : opp.OpportunityLineItems) {
                    OpportunityLineItem renewalLine = oli.clone(false, true, false, false);
                    renewalLine.OpportunityId = opp.Id;
                    renewalLine.EndDate__c = null;

                    renewalOppLineItems.add(renewalLine);
                }
            }

            insert renewalOppLineItems;
        }
    }

    private Date determineRenewalCloseDate(List<OpportunityLineItem> oppLineItems) {
        Date closestDate = oppLineItems[0].EndDate__c;

        for(OpportunityLineItem oppLine : oppLineItems) {
            if(closestDate > oppLine.EndDate__c) {
                closestDate = oppLine.EndDate__c;
            }
        }

        return closestDate;
    }

    private void updateQuoteDetails(zqu__Quote__c quote) {
        quote.OrderDate__c = System.today();

        if(quote.ShipConfirm__c != 'Sent' && quote.Channel__c.contains('EMC') && (quote.ConfProduct__c > 0 || quote.ConfSaaS__c > 0)) {
            quote.ShipConfirm__c = 'Ready';
        }
    }
}