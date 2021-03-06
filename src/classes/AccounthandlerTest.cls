@isTest(SeeAlldata=True)
public class AccounthandlerTest {
static testMethod void  AccounthandlerTest12()
    {
         account accobj= new Account();
         accobj.name ='Test1';
         accobj.Special_Handling__c = 'Standard';
         insert accobj;
         system.debug('Account Created' +  accobj);
         Map<Id,account> accountMap = new Map<Id,account>();
         accountMap.put(accobj.id,accobj);
         system.debug('accountMap' +  accountMap);
         system.debug('accobj.id' +  accobj.id);
         accobj.Special_Handling__c = 'EH - Executive Handling';
         system.debug('accountMap' +  accountMap);
         system.debug('accobj.id' +  accobj.id);
         
         Special_Handling_Instructions__c  sp =new Special_Handling_Instructions__c();
         sp.Handling_Instructions__c='test12';
         sp.Products__c='Datometry Hyper-Q for Pivotal Data Suite';
         sp.Account__c=accobj.id;
         insert sp;
         system.debug('Special Handling Instructions Created' +  sp);
        
        case cobj =new case();
         cobj.Special_Handling_Instructions__c ='test';
         cobj.Products__c='Datometry Hyper-Q for Pivotal Data Suite';
         cobj.AccountId=accobj.id;
         cobj.subject='TS-34';
         cobj.description='TS-34 : Test SS';
         insert cobj;
         system.debug('Case Created' +  cobj);
         system.debug('cobj.AccountId ' +  cobj.AccountId);
        
         if(accountMap.containskey(cobj.AccountId)){
         system.debug('inside if ' +  cobj.AccountId);
        // cobj.Special_Handling_Type__c  = accountMap.get(cobj.AccountId).Special_Handling__c;
         //system.debug('cobj.Special_Handling_Type__c ' + cobj.Special_Handling_Type__c);
         system.debug('accountMap.get(cobj.accountId).Special_Handling__c ' + accountMap.get(cobj.accountId).Special_Handling__c);
         //Special_Handling_Instructions__c myCondtest = new Special_Handling_Instructions__c();
         //myCondtest = [select id from Special_Handling_Instructions__c LIMIT 1];
         
        // update cobj;
        system.debug('Inserted');
         if(sp.account__c==cobj.AccountId && cobj.Products__c==sp.Products__c)
                {
                    cobj.Special_Handling_Instructions__c=sp.Handling_Instructions__c;
                    system.debug('cobj.Special_Handling_Instructions__c' + cobj.Special_Handling_Instructions__c);
                    system.debug('sp.Handling_Instructions__c' + sp.Handling_Instructions__c);
                    
                }  
        system.debug('After If');

         update accobj;
         update sp;
         update cobj;
        
    }
}
}

/*Static testMethod void Testmethod1()
{
    account ac = new account();
    ac.Name = 'TestAccount';
    insert ac;
    
    Case cs = new Case();
    cs.Special_Handling_Type__c = 'Executive Handling (Non-BRICE)';
    cs.Special_Handling_Instructions__c = 'Test Handling Instructions_Case';
    cs.Products__c = 'Alpine Chorus for Pivotal Data Suite';
    cs.AccountId = ac.id;
    insert cs;
    
    Special_Handling_Instructions__c sp = new Special_Handling_Instructions__c();
    sp.Handling_Instructions__c = 'Test Handling Instructions_Special_Handling_Instructions';
    sp.Products__c = 'Alpine Chorus for Pivotal Data Suite';
    sp.Account__c = ac.id;
    insert sp;
    
}
}*/