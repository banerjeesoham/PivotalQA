public class EscalateCase {
    public String caseId {get;set;}
    case caseObj;
    public EscalateCase(ApexPages.StandardController controller) {        
        caseObj = (Case)controller.getRecord();
        caseId = caseObj.Id;
       system.debug('caseobj'+caseobj);
    }
    public void getResponse(){
    System.debug('==========================>+entered');
    system.debug('caseobj'+caseobj);
    caseObj.IsEscalated= true;
       
         try{
          update caseObj;
         }
     catch(Exception e){
          ErrorLog.CreateER(e);//Exception captured in Utility Class Errorlog
       }

  }
}