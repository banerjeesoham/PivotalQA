/*******************************************************************************************************************
* Apex Class Name  : CaseCommentListController
* Test Class Naem  : CaseCommentListControllerTC      
* Version          : 1.0
* Function         : Used to Case Comments for Case Records
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Richa Gupta                 10/03/2017              intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/

Global class CaseCommentListController{
    public String caseNumber{get;set;}
    public Id caseId;
    public List<FeedItem> feedLst{get;set;}
    public Boolean message {get; set;}
    public ID getCaseID(){ return caseId; }
    public void setCaseID(ID s){
        caseId= s;
        CaseCommentListController();
    }
    
    //Used to get case comments from Cases
    public void CaseCommentListController(){
        feedLst = new List<FeedItem>();
        feedLst = [Select Id, ParentId, body , createdBy.Name, createdDate ,HasContent from FeedItem where ParentId =: caseID and type='TextPost' and Visibility='AllUsers' order by createdDate asc limit 5];
        message= true;
        if(feedLst.isEmpty()){
            message= false;
        }
    } 
    public list<FeedItem> getFeedLst(){
        return feedLst;
    }
}