/**
 * GenericClientSideListCtrl.cls
 * @description:  Generic ClientSide List Ctrl
 * @author Ricardo Visbal
 * @date 2014-May-02
 */

global without sharing class GenericClientSideListCtrl {

     public String columnList_p { 
        get;
        set {
            //System.debug('>>> columnList_p');
            if (columnList_p == null) {
                columnList_p = value;
                initialize();
            }
        }
    }

    public String controlId_p { 
        get;
        set {
            controlId_p = value;
        }
    }

    public String sObjectName_p { 
        get;
        set {
            //System.debug('>>> sObjectName_p');
            if (sObjectName_p == null) {
                sObjectName_p = value;
                //System.debug('>>> sObjectName_p='+sObjectName_p);
                initialize();
            }
        }
    }

    public Boolean showActionColumn_p { 
        get;
        set {
            showActionColumn_p = value;
            //System.debug('SET showActionColumn_p='+showActionColumn_p);
            if (showActionColumn_p == true) initColumnCount();  
        }
    }
    public Boolean showCheckColumn_p { 
        get;
        set {
            showCheckColumn_p = value;
            //System.debug('SET showCheckColumn_p='+showCheckColumn_p);
            if (showCheckColumn_p == true) initColumnCount();  
        }
    }
    public String controlTitle {get; set;}
    public String queryFilter {get; set;}
    public String hiddenColumnList {get; set;}
    public integer columnCount {get; set;}
    public List<String> resultColumnList {get; set;}
    public List<String> resultColumnAlternateList {get; set;}
    //public List<String> jsColumnList {get; set;}
    public String resultJSON {get; set;}
    public String controlDescriptionListJSON {get; set;}


    public List<ControlDescription> controlDescriptionList {get; set;}
    

    public Boolean showLetterFilter {get; set;}
    public Boolean showListFilter {get; set;} 
    
    public Boolean showPagination {get; set;}  
    public Boolean useRadio {get; set;}   
    public Boolean useFixedWidth {get; set;}   
    public Boolean isScrollable {get; set;} 
    public Boolean queryOnPageLoad {get; set;} 


    public Boolean queryBatch {get; set;} 
    public Integer queryBatchCount {get; set;} 
    public Integer queryMaxRecords {get; set;} 

    //Constructor
    public GenericClientSideListCtrl() {
        /*
        showLetterFilter = true;
        showListFilter = true;
        showActionColumn = false;
        showCheckColumn = true;
        useRadio = false;
        */
        
        columnCount = 0;
        resultColumnList = new List<String>();
        resultColumnAlternateList = new List<String>();
        controlDescriptionList = new List<ControlDescription>();
    }


    public void initialize() {
        //resultColumnList = new List<String>();
        
        //System.debug('??????');
        //System.debug(resultColumnList);
        if (resultColumnList.size() == 0) {
            //jsColumnList = new List<String>();
            resultColumnList = columnList_p.split(',');
            //System.debug('initialize columnCount='+columnCount);
            columnCount = columnCount + resultColumnList.size();
            //System.debug('initialize columnCount='+columnCount);
            //if (useRadio || showCheckColumn) columnCount =    columnCount + 1;

            for( integer x = 0; x < resultColumnList.size(); x++ ) {  
               resultColumnList[x] = resultColumnList[x].trim();
               //jsColumnList.add(String.valueOf(resultColumnList[x]).replace('.','_'));
            }

        }
        //resultJSON = JSON.serialize(queryObject());
        //System.debug(resultColumnList.size()); 
        //System.debug(jsColumnList.size()); 
        //System.debug('1. initialize sObjectName_p='+sObjectName_p);
       
        if (resultColumnList.size() > 0 && sObjectName_p != null && sObjectName_p != '') {
            //System.debug('----------'); 
            //System.debug('2. initialize sObjectName_p='+sObjectName_p);

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName_p);
            
            Map<String, Schema.SObjectField> mapFields = targetType.getDescribe().fields.getMap();
            double totalSize = 0;
            //System.debug(mapFields); 
            for( integer y = 0; y < resultColumnList.size(); y++ ) {  
                
                ControlDescription d = new ControlDescription();
                d.QueryName = resultColumnList[y].trim();
                d.HTMLName = String.valueOf(d.QueryName).replace('.','_');
                resultColumnAlternateList.add(d.HTMLName);
                d.IsText = true;
                d.IsBoolean = false;

                d.InputType = 'STRING';
                d.FieldSize = 100;

                Schema.SObjectField f = mapFields.get(resultColumnList[y]);
                if (f != null) {
                    Schema.DescribeFieldResult dr = f.getDescribe();
                    //System.debug(dr.getName()); // field name
                    //System.debug(dr.getType()); // field type
                    //System.debug(dr.getLength()); // field length
                    d.InputType = String.valueOf(dr.getType());
                    d.FieldSize = dr.getLength();
                    if (d.FieldSize == 0) d.FieldSize = 100;
                    d.HeaderTitle = dr.getLabel();
                }
                else {
                    d.HeaderTitle = cleanName(String.valueOf(d.QueryName));
                }

                if (d.InputType == 'BOOLEAN') {
                    d.IsText = false;
                    d.IsBoolean = true;
                    d.FieldSize = 50;
                }
                totalSize = totalSize + d.FieldSize ;
                controlDescriptionList.add(d);
            
            }

          

            if (controlDescriptionList != null) {
                for( ControlDescription d : controlDescriptionList) { 
                    d.FieldWidth = (d.FieldSize / totalSize) * 100;
                }

                controlDescriptionListJSON = JSON.serialize(controlDescriptionList);
            }
           

        
            
        }
        else {
            controlDescriptionListJSON = 'null';
        }

        /*
        // sObject types to describe
        String[] types = new String[]{sObjectName};
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) { 
            ////System.debug('Number of fields: ' + res.fields.getMap().size());

            // Get child relationships
            //Schema.ChildRelationship[] rels = res.getChildRelationships();
            //  if (rels.size() > 0) {
            //  //System.debug(res.getName() + ' has ' + rels.size() + ' child relationships.');
            //}
        }
        */

    }

    public string cleanName(string sourceString) {
        string result = sourceString.replace('__c','');
        result = result.replace('__r.',' ');
        result = result.replace('.',' ');
        result = result.replace('FirstName','First Name');
        result = result.replace('LastName','Last Name');
        result = result.replace('CompanyName','Company Name');
        result = result.replace('AccountName','Account Name');

        result = result.replace('MailingCity','Mailing City');
        result = result.replace('MailingState','Mailing State');
        result = result.replace('MailingStreet','Mailing Street');
        result = result.replace('MailingPostalCode','Mailing Postal Code');
        result = result.replace('MailingCountry','Mailing Country');

        result = result.replace('ShippingCity','Shipping City');
        result = result.replace('ShippingState','Shipping State');
        result = result.replace('ShippingStreet','Shipping Street');
        result = result.replace('ShippingPostalCode','Shipping Postal Code');
        result = result.replace('ShippingCountry','Shipping Country');

        result = result.replace('BillingCity','Billing City');
        result = result.replace('BillingState','Billing State');
        result = result.replace('BillingStreet','Billing Street');
        result = result.replace('BillingPostalCode','Billing Postal Code');
        result = result.replace('BillingCountry','Billing Country');

        result = result.replace('OtherCity','Other City');
        result = result.replace('OtherState','Other State');
        result = result.replace('OtherStreet','Other Street');
        result = result.replace('OtherPostalCode','Other Postal Code');
        result = result.replace('OtherCountry','Other Country');

        result = result.replace('AccountNumber','Account Number');
        result = result.replace('IsEnabled','Enabled');
        result = result.replace('IsDeleted','Deleted');
        return result;
    }

    public void initColumnCount() {
        //System.debug('initColumnCount columnCount='+columnCount);
        columnCount = columnCount + 1;
        //System.debug('initColumnCount columnCount='+columnCount);
    }



    @RemoteAction
    global static List<sObject> selectObject(string oName, string cList, string qFilter, string querySort, string qLimit){
        List<sObject> resultList = new List<sObject>();


        string query = 'SELECT Id, ';
        query += cList;
        query += ' FROM '+ oName ;
        if (qFilter != null && qFilter != '') {
            query += ' WHERE ' +  qFilter;
        }
        if (querySort != null && querySort != '') {
            query += querySort;
        }
        if (qLimit != null && qLimit != '') {
            query += qLimit;
        }
                         
        resultList = database.query( query );
        return resultList;
    }

    @RemoteAction
    global static List<sObject> queryAnyObject(string query){
        List<sObject> resultList = new List<sObject>();
        resultList = database.query( query );
        return resultList;
    }


    @RemoteAction
    global static Integer getNumericValue(string query){
        return database.countQuery( query );
    }


    @RemoteAction
    global static String getStringValue(string query){
        return '';//database.query( query );
    }


    public List<sObject> queryObject(){
        /*
        string objectName = 'Contact';
        string query = 'SELECT Id, ';
        query += columnList_p;
        query += ' FROM '+ sObjectName_p ;
        if (queryFilter != null && queryFilter != '') {
            query += ' WHERE ' +  queryFilter;
        }  
        return database.query( query );
        */
        return new List<sObject>();
    }


    @RemoteAction
    global static List<sObject> customAction(string cList){
        List<sObject> matchedContacts = new List<sObject>();
        return matchedContacts;
    }


    @RemoteAction
    global static String deleteObject(string oName, string recordId) {
        
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(oName);
        SObject genericObject = targetType.newSObject(recordId);
        delete genericObject;
        
        return recordId;
    }

    @RemoteAction
    global static List<sObject> saveObject(string oName, string jsonList){
        Type t = Type.forName('List<'+ oName + '>');
        system.debug(t);
        List<SObject> deserializeList = (List<SObject>)JSON.deserialize(jsonList, t);
        system.debug(deserializeList);
        //for (SObject o : lo) {
        //    //System.debug(o.getSObjectType().getDescribe().getName() + ', Name: ' + o.get('Name'));
        //}
        //Schema.DescribeSObjectResult cpDescribe = Contact_Point__c.sObjectType.getDescribe();
        //if (cpDescribe.isUpdateable()) {
            upsert deserializeList;
        //}
        
        return deserializeList;
    }


    @RemoteAction
    global static List<GenericResult> saveObjectWithResult(string oName, string jsonList){
        Type t = Type.forName('List<'+ oName + '>');
        system.debug(t);
        List<SObject> deserializeList = (List<SObject>)JSON.deserialize(jsonList, t);
        system.debug(deserializeList);

        //Database.SaveResult[] srList = Database.insert(deserializeList, false);
        Database.UpsertResult[] srList = Database.upsert(deserializeList, false);

        List<GenericResult> resultList = new List<GenericResult>();
        Integer listIndex = 0;
        for (Database.UpsertResult sr : srList) {
            resultList.add(new GenericResult(sr, deserializeList[listIndex]));
            listIndex ++;
        }
        
        return resultList;
    }

    global class GenericResult {
        
        public Database.UpsertResult Result { get; set; }
        public SObject CurrentObject { get; set; }

        public GenericResult(Database.UpsertResult pResult, SObject pObject){
            this.Result = pResult;
            this.CurrentObject = pObject;
        }
    }

    //dType: txt
    //dContentType: 'text/plain'
    @RemoteAction
    global static Document saveDocument(string dName, string fName, string dContent,string dContentType,string dType){
        List<Folder> fList = [SELECT Id, Name, DeveloperName, AccessType, IsReadonly, Type, NamespacePrefix, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
                                FROM Folder WHERE Name =: fName ];
        string folderId = '';
        
        if (fList.size() > 0) {
            if(!Test.isRunningTest()){
                folderId = fList[0].Id;
            } else{
                folderId = UserInfo.getUserId();
            }
        }
        else {
            //Folder f = new Folder(Name = fName, AccessType='Public', IsReadonly=false);
            //insert f;
            //folderId = f.Id;
        }

        Document d = new Document(); 
        d.Name = dName; 
        d.Body = Blob.valueOf(dContent); 
        d.ContentType = dContentType;
        d.Type = dType;
        d.FolderId = folderId;
        insert d;
        return d;
    }


    @RemoteAction
    global static List<ControlDescription> getObjectDescribe(string sObjectName_p) {
            
            List<ControlDescription> controlDescriptionList = new List<ControlDescription>();
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName_p);
            Map<String, Schema.SObjectField> mapFields = targetType.getDescribe().fields.getMap();

            for (Schema.SObjectField f : mapFields.values()) { 

                ControlDescription d = new ControlDescription();
                d.QueryName = '';
                d.HTMLName = '';
                d.HeaderTitle = '';

                d.IsText = true;
                d.IsBoolean = false;

                d.InputType = 'STRING';
                d.FieldSize = 100;

                if (f != null) {
                    Schema.DescribeFieldResult dr = f.getDescribe();
                    //System.debug(dr.getLength()); // field length
                    d.InputType = String.valueOf(dr.getType());
                    d.FieldSize = dr.getLength();
                    if (d.FieldSize == 0) d.FieldSize = 100;
                    d.QueryName = dr.getName();// field name
                    d.HTMLName = dr.getLabel();
                    d.HeaderTitle = dr.getLabel();
                    d.IsUpdateable = dr.isUpdateable();
                    d.IsCreateable = dr.isCreateable();
                    d.IsCustom = dr.isCustom() ;
                    d.IsAutoNumber = dr.isAutoNumber();
                    d.IsAccessible = dr.isAccessible();

                    d.IsCalculated = dr.isCalculated();
                    d.IsExternalID = dr.isExternalID();
                    d.IsFilterable = dr.isFilterable();
                    d.IsNillable = dr.isNillable();
                    d.IsSortable = dr.isSortable();
                    d.IsUnique = dr.isUnique();
                    d.CalculatedFormula = dr.getCalculatedFormula();
                    //d.PicklistValues = LIST<Schema.PicklistEntry> dr.getPicklistValues();
                }
               
                if (d.InputType == 'BOOLEAN') {
                    d.IsText = false;
                    d.IsBoolean = true;
                    d.FieldSize = 50;
                }
               
                controlDescriptionList.add(d);
            
            }

            return controlDescriptionList;
     
        
    }

    global class ControlDescription {
        
        public String QueryName { get; set; }
        public String HTMLName { get; set; }
        public String InputType { get; set; }
        public String HeaderTitle { get; set; }
        public double FieldSize { get; set; }
        public double FieldWidth { get; set; }
        
        public Boolean IsText { get; set; }
        public Boolean IsBoolean { get; set; }
        public Boolean IsUpdateable { get; set; }
        public Boolean IsCreateable { get; set; }

        public Boolean IsCustom { get; set; }
        public Boolean IsAutoNumber { get; set; }
        public Boolean IsAccessible { get; set; }
        public Boolean IsCalculated { get; set; }
        public Boolean IsExternalID { get; set; }
        public Boolean IsFilterable { get; set; }
        public Boolean IsNillable { get; set; }
        public Boolean IsSortable { get; set; }
        public Boolean IsUnique { get; set; }

        public String CalculatedFormula { get; set; }
        public String PicklistValues { get; set; }

        public ControlDescription(){}
        
    }

}