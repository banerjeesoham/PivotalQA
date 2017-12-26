public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    public OpportunityTriggerHandler() {}

    /* Context Overrides */

    protected override void beforeInsert() {
        updateFiscalYear();
        updateFirstProductDateOnAccount();
    }

    protected override void beforeUpdate() {
        updateFiscalYear();
        updateFirstProductDateOnAccount();
    }

    /* Private Methods */

    private void updateFiscalYear() {
        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            if (opp.CloseDate.year() <= 2016) {
                opp.Fiscal_Year__c = String.valueof(opp.CloseDate.year());
            } else if (opp.CloseDate >= date.newInstance(opp.CloseDate.year(), 2, 1).adddays(7) - math.mod(date.newInstance(1900, 1, 6).daysBetween(date.newInstance(opp.CloseDate.year(), 2, 1)), 7)) {
                opp.Fiscal_Year__c = String.valueof(Integer.valueof(opp.CloseDate.year() + 1));
            } else {
                opp.Fiscal_Year__c = String.valueof(opp.CloseDate.year());
            }

            opp.Fiscal_Year_Start_Date__c = date.newInstance(Integer.valueof(opp.Fiscal_Year__c) - 1, 2, 1).adddays(7) - math.mod(date.newInstance(1900, 1, 6).daysBetween(date.newInstance(Integer.valueof(opp.Fiscal_Year__c) - 1, 2, 1)), 7);
        }
    }


    private void updateFirstProductDateOnAccount() {
        List<Id> accIds = new List<Id>();
        List<Opportunity> bookedOppList = new List<Opportunity>();

        for (Opportunity opp : (List<Opportunity>) Trigger.new) {
            if (opp.StageName == 'Booked') {
                accIds.add(opp.AccountId);
                bookedOppList.add(opp);
            }
        }

        if (bookedOppList.size() > 0) {
            Map<Id, Account> originalAccountValues = setupAccountMap(accIds);
            Map<Id, Account> updatedAccountValues = originalAccountValues.deepClone();

            for (Opportunity opp : bookedOppList) {
                updateAccountPCFDate(opp, updatedAccountValues);
                updateAccountDataProductDate(opp, updatedAccountValues);
                updateAccountLabsDate(opp, updatedAccountValues);
            }

            Map<Id, Account> accountsToUpdate = generateMapOfAccountsToUpdate(originalAccountValues, updatedAccountValues);

            if (accountsToUpdate.size() > 0) {
                for (Account childAcc : accountsToUpdate.values()) {
                    if(childAcc.ParentId != null) {
                        Account parentAcc = new Account(Id = childAcc.ParentId,
                                                            First_purchase_Date_PCF__c = childAcc.Parent.First_purchase_Date_PCF__c,
                                                            First_Purchase_Date_Data_Products__c = childAcc.Parent.First_Purchase_Date_Data_Products__c,
                                                            First_Purchase_Date_Labs__c = childAcc.Parent.First_Purchase_Date_Labs__c);

                        updateParentAccountPCFDate(childAcc, parentAcc, accountsToUpdate);
                        updateParentAccountDataProductDate(childAcc, parentAcc, accountsToUpdate);
                        updateParentAccountLabsDate(childAcc, parentAcc, accountsToUpdate);
                    }
                }

                update accountsToUpdate.values();
            }
        }
    }

    private Map<Id, Account> setupAccountMap(List<Id> accIds) {
        return new Map<Id, Account>([
                SELECT Id,
                        First_Purchase_Date_Data_Products__c,
                        First_Purchase_Date_Labs__c,
                        First_purchase_Date_PCF__c,
                        ParentId,
                        Parent.First_Purchase_Date_Data_Products__c,
                        Parent.First_Purchase_Date_Labs__c,
                        Parent.First_Purchase_Date_PCF__c
                FROM Account
                WHERE Id IN :accIds
        ]);
    }

    private void updateAccountPCFDate(Opportunity opp, Map<Id, Account> updatedAccountValues) {
        /* Update the Account Cloud Foundry Date if:
        *  The Opportunity has a Cloud Foundry Product
        *  AND
        *  The Opportunity Close Date is lower than the current Cloud Foundry Date
        */
        if (opp.Total_Pivotal_CF_Product__c > 0 && (updatedAccountValues.get(opp.AccountId).First_Purchase_Date_PCF__c == null || updatedAccountValues.get(opp.AccountId).First_Purchase_Date_PCF__c > opp.CloseDate)) {
            updatedAccountValues.get(opp.AccountId).First_Purchase_Date_PCF__c = opp.CloseDate;
        }
    }

    private void updateParentAccountPCFDate(Account childAcc, Account parentAcc, Map<Id, Account> accountsToUpdate) {
        /* Update the Parent Account Cloud Foundry Date if:
        *  The Parent doesn't have a Date yet or it's greater than the Child Date
        *  Also check dates with existing accounts on the accountsToUpdate list
        */
        if ((parentAcc.First_purchase_Date_PCF__c == null && childAcc.First_purchase_Date_PCF__c != null) || parentAcc.First_purchase_Date_PCF__c > childAcc.First_purchase_Date_PCF__c) {
            parentAcc.First_purchase_Date_PCF__c = childAcc.First_purchase_Date_PCF__c;

            if(accountsToUpdate.get(parentAcc.Id) == null) {
                accountsToUpdate.put(parentAcc.Id, parentAcc);
            } else if(accountsToUpdate.get(parentAcc.Id).First_purchase_Date_PCF__c == null || accountsToUpdate.get(parentAcc.Id).First_purchase_Date_PCF__c > parentAcc.First_purchase_Date_PCF__c) {
                accountsToUpdate.get(parentAcc.Id).First_purchase_Date_PCF__c = parentAcc.First_purchase_Date_PCF__c;
            }
        }
    }

    private void updateAccountDataProductDate(Opportunity opp, Map<Id, Account> updatedAccountValues) {
        /* Update the Account Data Product Date if:
        *  The Opportunity has a Data Product
        *  AND
        *  The Opportunity Close Date is lower than the current Data Product Date
        */
        if (opp.Total_Data_Product__c > 0 && (updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Data_Products__c == null || updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Data_Products__c > opp.CloseDate)) {
            updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Data_Products__c = opp.CloseDate;
        }
    }

    private void updateParentAccountDataProductDate(Account childAcc, Account parentAcc, Map<Id, Account> accountsToUpdate) {
        /* Update the Parent Account Data Product Date if:
        *  The Parent doesn't have a Date yet or it's greater than the Child Date
        *  Also check dates with existing accounts on the accountsToUpdate list
        */
        if (parentAcc.First_Purchase_Date_Data_Products__c == null || parentAcc.First_Purchase_Date_Data_Products__c > childAcc.First_Purchase_Date_Data_Products__c) {
            parentAcc.First_Purchase_Date_Data_Products__c = childAcc.First_Purchase_Date_Data_Products__c;

            if(accountsToUpdate.get(parentAcc.Id) == null) {
                accountsToUpdate.put(parentAcc.Id, parentAcc);
            } else if(accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Data_Products__c == null || accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Data_Products__c > parentAcc.First_Purchase_Date_Data_Products__c) {
                accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Data_Products__c = parentAcc.First_Purchase_Date_Data_Products__c;
            }
        }
    }

    private void updateAccountLabsDate(Opportunity opp, Map<Id, Account> updatedAccountValues) {
        /* Update the Account Labs Date if:
        *  The Opportunity has a Labs Product
        *  AND
        *  The Opportunity Close Date is lower than the current Labs Date
        */
        if (opp.Total_Pivotal_Labs__c > 0 && (updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Labs__c == null || updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Labs__c > opp.CloseDate)) {
            updatedAccountValues.get(opp.AccountId).First_Purchase_Date_Labs__c = opp.CloseDate;
        }
    }

    private void updateParentAccountLabsDate(Account childAcc, Account parentAcc, Map<Id, Account> accountsToUpdate) {
        /* Update the Parent Account Labs Date if:
        *  The Parent doesn't have a Date yet or it's greater than the Child Date
        *  Also check dates with existing accounts on the accountsToUpdate list
        */
        if (parentAcc.First_Purchase_Date_Labs__c == null || parentAcc.First_Purchase_Date_Labs__c > childAcc.First_Purchase_Date_Labs__c) {
            parentAcc.First_Purchase_Date_Labs__c = childAcc.First_Purchase_Date_Labs__c;

            if(accountsToUpdate.get(parentAcc.Id) == null) {
                accountsToUpdate.put(parentAcc.Id, parentAcc);
            } else if(accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Labs__c == null || accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Labs__c > parentAcc.First_Purchase_Date_Labs__c) {
                accountsToUpdate.get(parentAcc.Id).First_Purchase_Date_Labs__c = parentAcc.First_Purchase_Date_Labs__c;
            }
        }
    }

    private Map<Id, Account> generateMapOfAccountsToUpdate(Map<Id, Account> originalAccountValues, Map<Id, Account> updatedAccountValues) {
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
        for (Account acc : updatedAccountValues.values()) {
            if(originalAccountValues.get(acc.Id).First_Purchase_Date_PCF__c != acc.First_purchase_Date_PCF__c ||
                    originalAccountValues.get(acc.Id).First_Purchase_Date_Data_Products__c != acc.First_Purchase_Date_Data_Products__c ||
                    originalAccountValues.get(acc.Id).First_Purchase_Date_Labs__c != acc.First_Purchase_Date_Labs__c
                    ) {

                accountsToUpdate.put(acc.Id, acc);
            }
        }
        return accountsToUpdate;
    }
}