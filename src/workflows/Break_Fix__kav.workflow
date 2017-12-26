<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Break_Fix_Approval_Alert</fullName>
        <description>Break Fix Approval Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Knowledge_Article_Templates/Break_Fix_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>Break_Fix_Rejection_Alert</fullName>
        <description>Break Fix Rejection Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Knowledge_Article_Templates/Break_Fix_Rejection_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Article_approval_is_Submitted_For_Review</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Review</literalValue>
        <name>Article approval is Submitted For Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_has_been_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Article has been Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_has_been_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Article has been Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_has_been_recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Article has been recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
