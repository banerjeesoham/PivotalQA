public with sharing class LoggedInUserController1 {

    public String logi { get; set; }
    public boolean isTech{get;set;}

    public LoggedInUserController1 (){
        isTech = false;
    }
    public PageReference logi() {
         pagereference pr = new pagereference('login?');
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
pagereference pr = new pagereference(system.label.PortalAccountURL);
 return pr;
}
public static Profile getLoggedInProfile() {
      Profile loggedinUser = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        return loggedinUser;
  }
    public pageReference getAllMenuItems()
{
 // getAllMenuItems1(); 

  return null; 

}  
    
   /* public static List<Navigation_Menu__c> getAllMenuItems1() {
      Profile loggedinUser = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
      return [SELECT Name, URL__c, (Select Name, URL__c from Navigation_Menu__r order by Sort_Order__c ASC) FROM Navigation_Menu__c where Profile_Name__c = :loggedinUser.Name and Parent_Menu__c = null order by Sort_Order__c ASC];
      
  }*/
  public void caseRe(){
  
  isTech = true;
  }

}