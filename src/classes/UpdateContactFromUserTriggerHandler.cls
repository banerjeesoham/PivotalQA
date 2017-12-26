/*******************************************************************************************************************
* Apex Class Name  : updateContactFromUserTriggerHandler
* Version          : 1.0
* Created Date     : 05 Sept 2017
* Function         : Class is used to populate User information into Contact records
* Modification Log :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Ranjithkumar Udhaya        05/09/2017              Intial version (Update User information into Contact Records.)
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class UpdateContactFromUserTriggerHandler{
    static List<PortalUserCreationMap__c > cSRecordsList =PortalUserCreationMap__c.getAll().Values();
    static String userQuery = 'SELECT Phone ,ProfileId ';
    static String contactQuery = 'SELECT Customer_Admin__c';
     public static void updateContactEnablePortalUserField(List<User> lstUser, Map<Id,User> OldMap,Boolean isInsert,Boolean isUpdate){
        set<Id> contactIds = new set<Id>(); 
        for(User usr : lstUser){
            if(isInsert)
                if(usr.isActive && usr.contactId != null)
                    contactIds.add(usr.contactId);
            if(isUpdate){
                if(usr != oldMap.get(usr.id) && usr.contactId != null){
                    contactIds.add(usr.contactId);
                }
                for(PortalUserCreationMap__c cSFields : cSRecordsList){
                    if(usr.get(csFields.Name) != oldMap.get(usr.id).get(csFields.Name) && usr.contactId != null){
                        contactIds.add(usr.contactId);
                        if(!userQuery.contains(csFields.Name))
                        userQuery = userQuery + ' , ' + cSFields.Name;
                        if(contactQuery.contains(csFields.Source__c))
                        contactQuery = contactQuery+' , '+csFields.Source__c;
                    }
                    
                }
            }
        } 
        if(!contactIds.isEmpty()){ 
            updateContact(contactIds);
        }
    }
    
    @future
    public static void updateContact(set<Id> contactIds){
        List<contact> lstContact = new List<Contact>();
        Map<Id,sObject> mapUser = new Map<Id, sObject>();
        String managerId = DataValueMap__c.getInstance('PortalManagerProfileId').Data_Value__c;     
        Map<Id,User> mapContact = new Map<Id,User>();
        for(PortalUserCreationMap__c cSFields : cSRecordsList){
            if(!userQuery.contains(csFields.Name))
            userQuery = userQuery + ' , ' + cSFields.Name;
            if(!contactQuery.contains(csFields.Source__c))
            contactQuery = contactQuery+' , '+csFields.Source__c;
        }
        userQuery+= ' FROM User WHERE contactId =:contactIds';
        contactQuery+= ' FROM Contact WHERE id =:contactIds';
        List<User> lstUser = Database.query(userQuery);
        for(User usr : lstUser){
            mapUser.put(usr.contactId, usr);
        }
        
        for(SObject sObj: (List<SObject>)Database.query(contactQuery)){
            Contact con = (contact) sObj;
            User usr = (user)mapUser.get(con.id);
            for(PortalUserCreationMap__c cSFields : cSRecordsList){
                if(cSFields.Name != 'ContactId')
                con.put(csFields.Source__c,usr.get(csFields.Name));
            }
            con.Customer_Admin__c = (usr.ProfileId==managerId ?true : false); 
            con.Zuora_Future__c = True;
            lstContact.add(con);
        }  
        if(!lstContact.isEmpty()){
            checkRecursive.checkContact = false;
            update lstContact;
        }  
    }
}