/*******************************************************************************************************************
* Apex TriggerName  : updateContactFromUserTrigger
* Version           : 1.0
* Created Date      : 05 Sept 2017
* Function          : User Trigger
* Modification Log  :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Ranjithkumar Udhaya        05/09/2017              Intial version (Update User information into Contact Records.)
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
trigger PS_UpdateContactFromUserTrigger on User (after insert, after update) {
    if(checkRecursive.runUserTrigger()){
        updateContactFromUserTriggerHandler.updateContactEnablePortalUserField(Trigger.New, Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
    }
}