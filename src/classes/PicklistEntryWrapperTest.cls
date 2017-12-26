@isTest
public class PicklistEntryWrapperTest{
    public static testMethod void picklist(){
        PicklistEntryWrapper pl = new PicklistEntryWrapper();
        pl.active = 'test';
        pl.defaultValue = 'test';
        pl.label = 'test';
        pl.value = 'test';
        pl.validFor = 'test';
    }  
}