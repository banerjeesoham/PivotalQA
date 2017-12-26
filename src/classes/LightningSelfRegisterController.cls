/*******************************************************************************************************************
* Apex Class Name  : LightningSelfRegisterController
* Test Class Name  : LightningSelfRegisterControllerTest
* Version          : 1.0
* Function         : Class is used for self registration page in portal
* Modification Log :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Hemavathi NM                    10/04/2017               Class is used for self registration page in portal
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
global class LightningSelfRegisterController {
    @TestVisible 
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }
        
    @AuraEnabled
    public static String selfRegister(String firstname ,String lastname, String email,String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword,String CompanyName,String Phone,String SecondaryPhone,String PivotalCustomerNumber,String BMOC,String Region,String Title,String MailingAddress1,String MailingAddress2,String state,String country,String City,String ZipCountryCode,String Timezone) {
        Savepoint sp = null;
        try {
            sp = Database.setSavepoint();
            if (firstname == null || String.isEmpty(firstname)) {
                return Label.firstname_is_required; 
            }
            if (lastname == null || String.isEmpty(lastname)) {
                return Label.Site.lastname_is_required;
            }
            
            if (email == null || String.isEmpty(email)) {
                return Label.Site.email_is_required;
            }
            
            if (email.endswith('@pivotal.io')){
            return Label.Validbuisnessid ;
            }
            
            User u = new User();
            u.Username = email;
            u.put('Email',email);
            
            u.FirstName = firstname;
            u.LastName = lastname;
            u.Best_Method_of_Contact__c=BMOC;
            u.Companyname=CompanyName;
            u.Region__c=Region;
            u.Title__c=Title;
            u.TimeZoneSidKey=TimeZone;
            u.Phone=Phone;
            u.MobilePhone=SecondaryPhone;
            u.Mailing_Address_1__c=MailingAddress1;
            u.Mailing_Address_2__c=MailingAddress2;
            u.Pivotal_Customer_Number__c=PivotalCustomerNumber;
            u.Country__c=country;
            u.City__c=City;
            u.State_Province__c=state;
            u.Zip_Country_Code__c=ZipCountryCode;
            String networkId = Network.getNetworkId();
            if(networkId != null && siteAsContainerEnabled('https://scdev-scdev-pivotal-support.cs14.force.com/Customers')) 
            {
                u.put('UserPreferencesHideS1BrowserUI',true);
            }
            
            String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
            nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
            u.put('CommunityNickname', nickname);
                     
            if (extraFields != null) {
                List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);        
                for (Object thisFieldObject : extraFieldsList) {
                    Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                    Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                    if(String.ValueOf(sof.getDescribe().getType()) == 'DOUBLE'){
                        //System.debug('decimalvalue---'+thisField.get('value'));
                        //u.put(sof, DOUBLE.valueOf(thisField.get('value')));
                    }else{
                        u.put(sof, thisField.get('value'));
                    }
                }
            }
            String userId = Site.createPortalUser(u, accountId, password);
            // create a fake userId for test.
            if (Test.isRunningTest()) {
                userId = 'fakeUserId';           
            }
            if (userId != null) { 
                if (password != null && password.length() > 1) {
                    ApexPages.PageReference lgn = Site.login(email, password, startUrl);
                    if(!Test.isRunningTest()) {
                        aura.redirect(lgn);
                    }
                }
                else {
                    ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                    if(!Test.isRunningTest()) {
                        aura.redirect(confirmRef);
                   }

                }
            }
            return null;
        }
        catch (Exception ex) {
            Database.rollback(sp);
            return ex.getMessage();            
        }
    }
    
    @AuraEnabled
    public static List<Map<String,Object>> getExtraFields(String extraFieldsFieldSet) { 
        List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get(extraFieldsFieldSet);
        if(!Test.isRunningTest()) {
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                String str = String.valueOf(f.getType());
                if(str == 'Picklist'){
                    fieldDetail.put('type', 'Picklist'); 
                }
               
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
               
            }}}
        return extraFields;
    }
 
    @AuraEnabled
    public static List<String> getpickval(String fieldPath) {
    List<String> options = new List<String>();
    Map<String, Schema.SObjectType> GlobalMap = Schema.getGlobalDescribe();
    Schema.DescribeSObjectResult obj = GlobalMap.get('User').getDescribe();
    Schema.SObjectField fieldResult = obj.Fields.getMap().get(fieldPath); 
        List<Schema.PicklistEntry> ple = fieldResult.getDescribe().getpicklistValues();
        for (Schema.PicklistEntry f: ple) { 
             options.add(f.getLabel()); 
        } 
   return options;
 }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
    
    List < String > allOpts = new list < String > ();
    // Get the object type of the SObject.
    Schema.sObjectType objType = objObject.getSObjectType();
    
    // Describe the SObject using its object type.
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
    
    // Get a map of fields for the SObject
    map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
    
    // Get the list of picklist values for this field.
    list < Schema.PicklistEntry > values =
    fieldMap.get(fld).getDescribe().getPickListValues();
    
    // Add these values to the selectoption list.
    for (Schema.PicklistEntry a: values) {
    allOpts.add(a.getValue());
    }    
    allOpts.sort();
    return allOpts;
    }        
}