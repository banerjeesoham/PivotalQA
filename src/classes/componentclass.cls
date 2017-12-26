public class componentclass {
public String selectedAsset{ get; set; }
 public String logi { get; set; }
    public boolean isTech{get;set;}
    public boolean Home{get;set;}
  public PageReference logi() {
  
         pagereference pr = new pagereference('login?');
 return pr;
   
       
    }
    public PageReference Home() {
  
         pagereference pr = new pagereference('/pivotalcustomersupport?');
 return pr;
   
       
    }
 public PageReference callingarticels() {
 string ID = selectedAsset;
 system.debug('selectedAsset'+selectedAsset);
 
         pagereference pr = new pagereference('https://scdev-scdev-pivotal-support.cs14.force.com/demo/articles/How_To/'+id);
 return pr;
   
       
    }
    

    public String knowl { get; set; }

    public PageReference knowl() {
    pagereference pr = new pagereference('/apex/Topicdetail');
 return pr;
        
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
}