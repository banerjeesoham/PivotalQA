public class Topicdetail {
public string selectedAsset {get;set;}
public string topicName{get;set;}
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
    redirect.getParameters().put('name',topicName);
    redirect.setRedirect(true); 

    return redirect;
    }

public list<Topic> tops{get;set;}
public Topicdetail () {
set<id>tid=new set<id>();
tops=[SELECT Id,Name,networkid FROM Topic where networkid =: system.label.Portalcommunityid];
}
}