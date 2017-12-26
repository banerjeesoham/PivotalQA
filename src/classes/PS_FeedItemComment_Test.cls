@isTest
public class PS_FeedItemComment_Test {
 	static testMethod void  FeedItemCommentTriggerHandlerTest(){
       TestDataUtil.dataValueMapCSData();
       Case cObj = TestDataUtil.createTechnicalCase();
       system.assert(cObj.Id != null);
       FeedItem feed = TestDataUtil.createFeedItem(cObj.Id,'AllUsers');
       system.assert(feed.Id != null);
	   Test.startTest();
           Contact cont = TestDataUtil.createPortalContact();
           system.assert(cont != null);
           User usr = [Select Id , ContactId , AccountId from User where isActive = true and Profile.Name='Pivotal - Community Manager' limit 1];
           system.assert(usr != null,'Issue in creating User');
           Case cObj1;
            System.runAs(usr){
               cObj1 = TestDataUtil.createCaseByPortalUser(usr);
               System.assert(cObj1.Id != null,'Case not created');
            }
           cObj1.Status = 'Solved';
           update cObj1;
       Test.stopTest();

       System.runAs(usr){
           FeedItem ifeed = TestDataUtil.createFeedItem(cObj1.Id,'AllUsers');
           FeedItem ifeed2 = TestDataUtil.createFeedItem(cObj1.Id,'AllUsers');
           system.assert(ifeed.Id != null);
       }
    }
    
    static testMethod void  addPostOnTechClosedCase(){
       TestDataUtil.dataValueMapCSData();
       User usr = [Select Id , contactId,AccountId from User where isActive = true and Profile.Name='Pivotal - Community Manager' limit 1];
       system.assert(usr != null,'Issue in creating User');
       Case cObj1;
        System.runAs(usr){
           cObj1 = TestDataUtil.createCaseByPortalUser(usr);
           system.assert(cObj1.Id != null);
        }
       Entitlement ent = TestDataUtil.createEntitlement(cObj1.AccountId);
       System.assert(ent!=null);
       cObj1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical').getRecordTypeId();
       cObj1.EntitlementId = ent.Id;
       cObj1.Status = 'Closed';
       update cObj1;
       System.runAs(usr){
           FeedItem ifeed = TestDataUtil.createFeedItem(cObj1.Id,'AllUsers');
           system.assert(ifeed.Id != null);
       }
    }  
    
    static testMethod void  addPostOnClosedCase(){
       TestDataUtil.dataValueMapCSData();
       User usr = [Select Id , ContactId , AccountId from User where isActive = true and Profile.Name='Pivotal - Community Manager' limit 1];
       system.assert(usr != null,'Issue in creating User');
       Case cObj1;
        System.runAs(usr){
           cObj1 = TestDataUtil.createCaseByPortalUser(usr);
           system.assert(cObj1.Id != null);
        }
       cObj1.Status = 'Closed';
       update cObj1;
       System.runAs(usr){
           FeedItem ifeed = TestDataUtil.createFeedItem(cObj1.Id,'AllUsers');
           system.assert(ifeed.Id != null);
       }
    }  
    
    
    static testMethod void  addPostonArticles(){
       TestDataUtil.dataValueMapCSData();
        Break_Fix__kav bf = new Break_Fix__kav();
        bf.Title = 'Test Articles';
        bf.UrlName = 'TestArticles';
        bf.Symptom__c = 'Test Articles';
        bf.Resolution__c = 'Test Articles';
        bf.Product__c  = 'Alpine Chorus for Pivotal Data Suite';
        insert bf;
        System.assert(bf.Id!=null);
        String arId = [SELECT KnowledgeArticleId FROM Break_Fix__kav WHERE Id = :bf.Id].KnowledgeArticleId;
        DatavalueMap__c  csDataList = DatavalueMap__c.getInstance('ArticleTypes');
        csDataList.Data_Value__c =arId.substring(0,3);
        update csDataList;
        System.assertEquals(arId.substring(0,3),csDataList.Data_Value__c , 'Not Match');
        KbManagement.PublishingService.publishArticle(arId, true);
        
        FeedItem ifeed = TestDataUtil.createFeedItem(arId,'AllUsers');
        system.assert(ifeed.Id != null);
        system.assertEquals(ifeed.ParentId ,arId);
        FeedComment cfeed = TestDataUtil.createfeedComment(ifeed.Id);
        system.assert(cfeed.Id != null);
    }
 }