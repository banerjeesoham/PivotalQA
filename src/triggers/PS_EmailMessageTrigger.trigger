/*******************************************************************************************************************
* Trigger Name  : EmailMessageTrigger
* Version          : 1.0
* Created Date     : 23 August 2017
* Function         : Trigger On EmailMessage object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/23/2017            intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
trigger PS_EmailMessageTrigger on EmailMessage (after insert,after update) {
    if(Trigger.isAfter && Trigger.isInsert) {
        List<EmailMessage> processEmailLst= new List<EmailMessage>();
        Map<Id,EmailMessage> caseEmailMessageMap = new Map<Id,EmailMessage>();
        Map<Id,EmailMessage> responseEmailMessageMap = new Map<Id,EmailMessage>();
        for(EmailMessage emailObj : Trigger.New) {
            if(!emailObj.Incoming && (emailObj.status == '2' || emailObj.status == '3')) {
                processEmailLst.add(emailObj); 
            }
            if(String.ValueOf(emailObj.ParentId).StartsWith('500') && emailObj.Status == '0'){
                caseEmailMessageMap.put(emailObj.ParentId,emailObj);
            }
            if(emailObj.Incoming && (emailObj.status == '2' && String.valueOf(emailObj.ParentId).StartsWith('500'))){
                responseEmailMessageMap.put(emailObj.ParentId,emailObj);
            }
            
        }
        if(!processEmailLst.isEmpty()) {
            PS_EmailMessageTriggerHandler.RelatedCaseRecord(processEmailLst);
        }
        if(!responseEmailMessageMap.isEmpty()) {
            PS_EmailMessageTriggerHandler.updateCaseOnResponse(responseEmailMessageMap);
        }
        if(!caseEmailMessageMap.isEmpty()){
            /*Logic to Create PWS Account and PWS Contact*/
            PS_EmailMessageTriggerHandler.email2CaseRouting(caseEmailMessageMap);
        }
        
    }
}