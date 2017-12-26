public class ArticleLists {
  
  
       

  public string topicName{get;set;}

    public String callingarticels { get; set;}
    public String getCallingarticel(){
        return null;
    }
   public Map<String,list<KnowledgeArticleVersion>> knowledgeArticles{get;set;}
   public  List<Break_Fix__kav> bf {get;set;}
   public  List<Tools__kav> tool {get;set;}
   public  List<Troubleshooting_Guide__kav> ts {get;set;}
   public  List<How_To__kav> ht {get;set;}
    public  List<KnowledgeArticleVersion> kv {get;set;}
    public set<String> articleTypes{get;set;}
    public String logi { get; set; }
    public boolean isTech{get;set;}
public String selectedAsset{ get; set; }
    public PageReference logi() {
         pagereference pr = new pagereference('login?');
 return pr;
   
        return null;
    }
 public PageReference callingarticels() {
 string ID = selectedAsset;
 system.debug('selectedAsset'+selectedAsset);
 
         pagereference pr = new pagereference('https://scqa-pivotal--scqa.cs19.force.com/pivotalcustomersupport/articles/Break_Fix/'+id);
 return pr;
   
       
    }
    

    public String knowl { get; set; }

    public PageReference knowl() {
    pagereference pr = new pagereference('apex/Topicdetail');
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

public ArticleLists(){
   isTech = false;
   String ID = ApexPages.currentPage().getParameters().get('id');
   topicName = ApexPages.currentPage().getParameters().get('name');
   articleTypes = new Set<String>();
   
    knowledgeArticles = new Map<String,list<KnowledgeArticleVersion>>();
    List<KnowledgeArticleVersion> kavObj = [Select Title ,KnowledgeArticleId, UrlName ,Summary ,articleType from KnowledgeArticleVersion where  PublishStatus='Online' and id in(SELECT EntityId FROM TopicAssignment WHERE TopicId=:ID)];
    DescribeSObjectResult objType = KnowledgeArticleVersion.getSObjectType().getDescribe();
    Map<String, SObjectField> fields = objType.fields.getMap();
    Set<String> fieldSet = fields.keySet();
    set<string>titelset=new set<string>();
    for(KnowledgeArticleVersion kv :kavObj ){
        titelset.add(kv.Title );
        Map<String,String> articleMap = new Map<String,String>();
        articleMap.put(kv.UrlName,kv.Title);
        String str = kv.articleType;
        str = str.remove('__kav');
        
        if(knowledgeArticles.containsKey(str)){
            knowledgeArticles.get(str).add(kv);
        }else{
            knowledgeArticles.put(str , new list<KnowledgeArticleVersion>{kv});
        }
        articleTypes.add(kv.articleType);
    }
    
    System.debug('knowledgeArticles----'+knowledgeArticles);
    for(String s:fieldSet)
    {
        SObjectField fieldToken = fields.get(s);
        DescribeFieldResult selectedField = fieldToken.getDescribe();
        System.debug(selectedField.getName());
    }
    /*
    bf = [Select Title,Id,UrlName from Break_Fix__kav where PublishStatus='Online' and Language = 'en_US' and Title in:titelset];
    tool = [Select Title ,Id from Tools__kav where PublishStatus='Online' and Language = 'en_US' and Title in:titelset];
    ts = [Select Title ,Id from Troubleshooting_Guide__kav where PublishStatus='Online' and Language = 'en_US'and Title in:titelset];
    ht = [Select Title, Id,UrlName from How_To__kav where PublishStatus='Online' and Language = 'en_US'and Title in:titelset]; */
    }
}