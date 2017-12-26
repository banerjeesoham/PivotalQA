/*******************************************************************************************************************
* Apex Class Name  : UpdateCase 
* Test Class Name  : UpdateCase _Test
* Version          : 1.0
* Function         : 
* Modification Log :
*
* Developer                        Date                       Description
* ------------------------------------------------------------------------------------------------------------------
* Richa Gupta
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
public class UpdateCase {
    public String caseId {get;set;}
    public user usr {get;set;}
    case caseObj;
    public UpdateCase(ApexPages.StandardController controller) {        
        caseObj = (Case)controller.getRecord();
        caseId = caseObj.Id;
        usr = [Select ID, ContactId, ProfileId from user where id=:userinfo.getUserID()];              
    }
   
    public void getResponse()
    {
        caseObj.Requestupdate__c= true;
        update caseObj;
    }
}