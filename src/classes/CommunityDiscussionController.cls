public class CommunityDiscussionController {
    public List<FeedItem> lstFeedItems {get;set;}
    public List<Topic> lstTopic {get;set;}
    public List<TopicWrapper> lstTopicWrapper {get;set;}
    public List<FeedItemWrapper> lstFeedItemWrapper {get;set;}
    public string selectedAsset {get;set;}
    public string tname {get;set;}
public String logi { get; set; }
    public boolean isTech{get;set;}

    public PageReference logi() {
         pagereference pr = new pagereference('/login?');
 return pr;
   
        return null;
    }


    public String knowl { get; set; }

    public PageReference knowl() {
    pagereference pr = new pagereference(system.label.TopicpageUrl);
 return pr;
        return null;
    }


    public String foru { get; set; }

    public PageReference foru() {
        pagereference pr = new pagereference(system.label.communityurl);
 return pr;
    }


    public String ca { get; set; }

    public PageReference ca() {
          pagereference pr = new pagereference(system.label.PortalcaseURL);
 return pr;
    }


    public String con { get; set; }

    public PageReference con() {
    pagereference pr = new pagereference(system.label.PortalcontactURL);
 return pr;
        
    }


    public String save { get; set; }
    
 public pageReference save()
{system.debug('in');
pagereference pr = new pagereference(system.label.PortalaccountURL);
 return pr;
}

    public PageReference callingvf() {
     PageReference redirect = new PageReference('/apex/ArticleListPage'); 
//String ID = ApexPages.currentPage().getParameters().get('id');
    // pass the selected asset ID to the new page
   // system.debug('id'+id);
    redirect.getParameters().put('id',selectedAsset ); 
    redirect.setRedirect(true); 

    return redirect;
    }
    public CommunityDiscussionController() {
        
        Id topicId = ApexPages.currentPage().getParameters().get('tid');
        tname = ApexPages.currentPage().getParameters().get('tname');
        if(topicId != null) {
            lstFeedItems = [SELECT Id, Body, Title, LikeCount, LastEditDate, CommentCount, CreatedBy.Name, Type, LastModifiedDate FROM FeedItem where Id IN (SELECT EntityId FROM TopicAssignment where TopicId = :topicId)];
            AggregateResult[] groupedResults = [SELECT count(Id) votecount, FeedItemId feedItemId FROM FeedPollVote where FeedItemId IN :lstFeedItems group by FeedItemId];
            Map<Id, integer> mapVotes = new Map<Id, integer>();
            for (AggregateResult ar : groupedResults)  {
                mapVotes.put((Id)ar.get('feedItemId'), (Integer)ar.get('votecount'));
            }
            lstFeedItemWrapper = new List<FeedItemWrapper>();
            for(FeedItem fi : lstFeedItems ) {
                FeedItemWrapper fiw = new FeedItemWrapper();
                fiw.feedItem = fi;
                fiw.voteCount = mapVotes.containsKey(fi.Id)?mapVotes.get(fi.Id):0;
                lstFeedItemWrapper.add(fiw);    
            }

        } else {
            lstTopic = [SELECT Id, Name FROM Topic where networkid =: system.label.Portalcommunityid];
            List<EntitySubscription> EntitySubscriptionlist = [select id, parentid, subscriberid from EntitySubscription Where parentid in : lstTopic];
            Map<Id, List<EntitySubscription>> mapTopicWithSubsciption = new Map<Id, List<EntitySubscription>>();
            for(EntitySubscription es : EntitySubscriptionlist) {
                if(mapTopicWithSubsciption.containsKey(es.parentid)) {
                    List<EntitySubscription> tempList = mapTopicWithSubsciption.get(es.parentid);
                    tempList.add(es);
                } else {
                    mapTopicWithSubsciption.put(es.parentid, new List<EntitySubscription>{es});
                }
            }
            
            List<TopicAssignment> lstTopicAssignment = [Select EntityId, TopicId From TopicAssignment where EntityType = 'FeedItem' and TopicId IN :lstTopic];
            Set<Id> entityIds = new Set<Id>();
            Map<Id, List<Id>> mapTopicWithEntity = new Map<Id, List<Id>>();
            for(TopicAssignment ta : lstTopicAssignment) {
                if(mapTopicWithEntity.containsKey(ta.TopicId)) {
                    List<Id> tempList = mapTopicWithEntity.get(ta.TopicId);
                    tempList.add(ta.EntityId);
                } else {
                    mapTopicWithEntity.put(ta.TopicId, new List<Id>{ta.EntityId});
                }
                entityIds.add(ta.EntityId);
            }
            List<FeedItem> lstFeedItems = [SELECT Id, Body, Title, LikeCount FROM FeedItem where Id IN :entityIds];
            Map<Id, List<FeedItem>> mapEnityFeedItems = new Map<Id, List<FeedItem>>();
            for(FeedItem fi : lstFeedItems) {
                if(mapEnityFeedItems.containsKey(fi.Id)) {
                    List<FeedItem> tempList = mapEnityFeedItems.get(fi.Id);
                    tempList.add(fi);
                } else {
                    mapEnityFeedItems.put(fi.Id, new List<FeedItem>{fi});
                }
            }
            
            lstTopicWrapper = new List<TopicWrapper>();
            
            for(Topic t : lstTopic) {
                TopicWrapper tw = new TopicWrapper();
                tw.topic = t;
                tw.postCount = mapTopicWithSubsciption.containsKey(t.Id)?mapTopicWithSubsciption.get(t.Id).size():0;
                integer followerCount = 0;
                if(mapTopicWithEntity.containsKey(t.Id)) {
                    for(Id entId : mapTopicWithEntity.get(t.Id)) {
                        List<FeedItem> lstFI = mapEnityFeedItems.get(entId);
                        followerCount += lstFI.size();
                    }
                }
                tw.followerCount = followerCount;
                lstTopicWrapper.add(tw);
            }
        }
    }
    
    public class TopicWrapper {
        public Topic topic {get;set;}
        public integer followerCount {get;set;}
        public integer postCount {get;set;}
    }
    
    public class FeedItemWrapper {
        public FeedItem feedItem {get;set;}
        public integer voteCount {get;set;}
    }
}