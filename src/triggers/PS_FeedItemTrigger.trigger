/*******************************************************************************************************************
* Apex Trigger Name  :  FeedItemTrigger
* Version          : 1.0
* Created Date     : 28 August 2017
* Function         : Trigger for FeedItem object
* Modification Log :
*
* Developer                   Date                    Description
* ------------------------------------------------------------------------------------------------------------------
* Karthik.A.S               08/28/2017            intial version
* --------------------------------------------------------------------------------------------------------------------
*******************************************************************************************************************/
trigger PS_FeedItemTrigger on FeedItem (after insert, after Update,before insert) {
    /*After insert & update of post on article*/
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        FeedItemCommentTriggerHandler feedItemObj = new FeedItemCommentTriggerHandler ();
        feedItemObj.feedItemMethod();
    }
    /*
    if(Trigger.isBefore && trigger.isInsert){
        System.debug('I am called');
        for(feedItem fi : Trigger.New){
             system.debug('Status change--'+fi.Createdby);
             system.debug('Status change--'+fi.ParentId);
        }
    }
    list<feeditem>feedlist= new list<feeditem>();
    if(Trigger.isAfter && Trigger.isInsert) {
        for(feeditem feedinsert:trigger.new){
            if(feedinsert.Visibility !='InternalUsers'&&feedinsert.type=='TextPost'){
                feedlist.add(feedinsert);
                
            }
            
        }
        
    }
    if(!feedlist.isempty()){
        FeeditemHandler.setFirstResponseandAutoResponse(Trigger.new);
        FeeditemHandler.setMilestoneDate(Trigger.new);
        
        
    }*/
    if(Trigger.isAfter && Trigger.isInsert) {
    system.debug('calling');
        FeedItemHandler.updateCaseRecord(Trigger.new);
        FeedItemHandler.setMilestoneDate(Trigger.new);
        
    }
    
    
}