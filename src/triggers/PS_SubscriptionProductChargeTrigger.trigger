/*******************************************************************************************************************
* Apex Trigger Name  : PS_SubscriptionProductChargeTrigger
* Version          : 1.0
* Created Date     : 28 August 2017
* Function         : Trigger for  SubscriptionProductCharge object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/28/2017            intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
trigger  PS_SubscriptionProductChargeTrigger on Zuora__SubscriptionProductCharge__c (after insert) {
    list<Zuora__SubscriptionProductCharge__c>subinsert= new list<Zuora__SubscriptionProductCharge__c>();
    for(Zuora__SubscriptionProductCharge__c  checkskuvalue : trigger.new){
        if(checkskuvalue.Zuora__ProductSKU_Product__c !=null&&checkskuvalue.Zuora__Account__c !=null){
            
            subinsert.add(checkskuvalue);
        }
        
        
    }
    if(!subinsert.isempty()){
        PS_SubscriptionProductChargeHandler.Entitlementcreation(subinsert);
    }
    
    
}