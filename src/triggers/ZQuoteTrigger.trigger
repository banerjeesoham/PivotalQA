trigger ZQuoteTrigger on zqu__Quote__c (after insert, before update) {
    new ZQuoteTriggerHandler().run();
}