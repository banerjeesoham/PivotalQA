/*******************************************************************************************************************
* Apex Class Name  : PicklistEntryWrapper
* Version          : 1.0
* Function         : Class is Used for Picklist entry in PicklistFieldController
* Modification Log :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Hemavathi NM        10/11/2017                    Used for Picklist entry in PicklistFieldController
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class PicklistEntryWrapper{
    
   public PicklistEntryWrapper(){            
   }
   public String active {get;set;}
   public String defaultValue {get;set;}
   public String label {get;set;}
   public String value {get;set;}
   public String validFor {get;set;}
}