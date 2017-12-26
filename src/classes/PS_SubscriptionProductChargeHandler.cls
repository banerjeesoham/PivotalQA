/*******************************************************************************************************************
* Apex Class Name  : PS_SubscriptionProductChargeHandler
* Test Class Name  : PS_SubscriptionProductChargeHandler_TC
* Version          : 1.0
* Created Date     : 01 August 2017
* Function         : class is used to create entitelment when SubscriptionProductCharge Sku Matches product SKU 
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/28/2017            intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class PS_SubscriptionProductChargeHandler{
    
    //this method is used to create entitelment when SubscriptionProductCharge Sku Matches product SKU
    public static void Entitlementcreation(list<Zuora__SubscriptionProductCharge__c> subscriptionList){
    
        list<Entitlement>entitelementcreation= new list<Entitlement>();
        Set<String> skuSet = new Set<String>();
        for(Zuora__SubscriptionProductCharge__c sub :subscriptionList){
            skuSet.add(sub.Zuora__ProductSKU_Product__c);   
        }
        if(!skuSet.isEmpty()){
            Map<String,list<ProductEntitlementMap__c>> skuWithProductMap = new Map<String,list<ProductEntitlementMap__c>>();
            Set<string> entProcess = new Set<string>();
            for(ProductEntitlementMap__c prod :[select id,Name,Product_SKU__c,Entitlement_Process__c from ProductEntitlementMap__c WHERE Product_SKU__c =: skuSet]){
                if(!skuWithProductMap.containsKey(prod.Product_SKU__c)){
                    skuWithProductMap.put(prod.Product_SKU__c, new list<ProductEntitlementMap__c> {prod});
                }else{
                    skuWithProductMap.get(prod.Product_SKU__c).add(prod);
                }
                entProcess.add(prod.Entitlement_Process__c);
            }
            Map<String,String> slaMap = new Map<String,String>();
            for(SlaProcess slaProc : [SELECT Id ,Name,IsActive From SlaProcess Where Name=: entProcess and IsActive = true]){
                slaMap.put(slaProc.Name,slaProc.Id);
            }
            
            for(Zuora__SubscriptionProductCharge__c sub : subscriptionList){
                if(sub.Zuora__ProductSKU_Product__c != null && !skuWithProductMap.isEMpty() &&skuWithProductMap.containsKey(sub.Zuora__ProductSKU_Product__c)){
                    for(ProductEntitlementMap__c prod : skuWithProductMap.get(sub.Zuora__ProductSKU_Product__c)){
                        Entitlement ent= new Entitlement();
                        ent.Name = prod.Name;
                        if(!slaMap.isEmpty() && slaMap.containsKey(prod.Entitlement_Process__c)){
                            ent.slaprocessid = slaMap.get(prod.Entitlement_Process__c);
                            ent.Name = prod.Name+'_'+prod.Entitlement_Process__c;
                        }                       
                        ent.startdate=date.newinstance(sub.createddate.year(), sub.createddate.month(), sub.createddate.day());
                        ent.Enddate=date.newinstance(sub.createddate.year(), sub.createddate.month(), sub.createddate.day())+365;
                        ent.accountid=sub.Zuora__Account__c; 
                        ent.Subscription__c=sub.Zuora__Subscription__c;
                        //ent.Products__c=sub.Zuora__Product__c;
                        ent.ProductEntitlementMap__c = prod.Id;
                        ent.Product_Descriptions__c=sub.Zuora__Description__c;
                        entitelementcreation.add(ent);                      
                    }
                }
            }
            if(!entitelementcreation.isempty()){
                try{
                    insert entitelementcreation;
                    }
                catch(Exception e){
                     ErrorLog.CreateER(e);// Catches Exception in Utility Class ErrorLog
                 }
            }
        }
    }
    
}