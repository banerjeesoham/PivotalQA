<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Owner_Admin</fullName>
        <field>OwnerId</field>
        <lookupValue>pivotaladmin@pivotal.io</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Contact - Owner Admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Company_Account_Name</fullName>
        <field>Contact_Company__c</field>
        <formula>Account.Name</formula>
        <name>Set &apos;Contact Company&apos; - Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>refedge__Joined_Reference_Program_Date</fullName>
        <description>Update date is written here when &apos;reference program member&apos; flag is first set to checked</description>
        <field>refedge__Joined_Reference_Program__c</field>
        <formula>Today()</formula>
        <name>Joined Reference Program Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>RPS_Contact</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://sf.visualcompliance.com/RPS_SF_WS/ContactNotificationService.asmx</endpointUrl>
        <fields>Email</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>LastName</fields>
        <fields>MailingCity</fields>
        <fields>MailingCountry</fields>
        <fields>MailingState</fields>
        <fields>MailingStreet</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>sfintegration@pivotal.io</integrationUser>
        <name>RPS Contact</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>RPS Contact Change</fullName>
        <actions>
            <name>RPS_Contact</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>OR(isNew(),  			isChanged(FirstName), 			isChanged(LastName), 			isChanged(Email), 			isChanged(MailingCountry) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set %27Contact Company%27</fullName>
        <actions>
            <name>Set_Contact_Company_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Contact_Company__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>For a new Contact, if the Contact Company is left blank, will provide the Account Name in this field.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>refedge__WR_InsertJoinedReferenceProgramDate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Depricated(Bound 8)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
