<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Automated_notification_alert</fullName>
        <description>Automated notification alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfintegration@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Automated_notification_email_template</template>
    </alerts>
    <alerts>
        <fullName>Customer_Service_Email_Ticket_pivotal_io_alert</fullName>
        <description>Customer Service Email Ticket - pivotal.io alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Customer_Service_Email_Ticket_pivotal_io_Template</template>
    </alerts>
    <alerts>
        <fullName>EMC_Federation_Email_Ticket_Alert</fullName>
        <description>EMC Federation Email Ticket Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/EMC_Federation_Email_Ticket_Template</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification</fullName>
        <ccEmails>global-csr@pivotal.io.scqa, ehsp-escalations@pivotal.io.scqa</ccEmails>
        <description>Email Notification for cases through EH/SP email escalation channel.</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Email_Template_for_cases_through_EH_SP_email_escalation_channel</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_the_CSR_CE_team_that_an_Update_Request_was_made</fullName>
        <description>Email notification to the CSR &amp; CE team that an Update Request was made.</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer_Engineer</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Customer_Service</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>david.raffensperger@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Request_Update_Template_for_CSR_and_CE</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_the_user_who_requested_update</fullName>
        <description>Email notification to the user who requested update.</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>david.raffensperger@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Request_Update</template>
    </alerts>
    <alerts>
        <fullName>Entitlements_Milestone_missed</fullName>
        <ccEmails>gss-ce-managers@pivotal.io.notify</ccEmails>
        <ccEmails>Support-SPM@pivotal.io.notify</ccEmails>
        <description>Entitlements Milestone missed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Entitlements</template>
    </alerts>
    <alerts>
        <fullName>Internal_notification_for_Support_Escalations</fullName>
        <description>Internal notification for Support Escalations</description>
        <protected>false</protected>
        <recipients>
            <recipient>Support_Escalations_Distribution_List</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Internal_notification_for_Support_Escalations</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_CS_CE_about_Support_Escalation</fullName>
        <description>Notification to CS/CE about Support Escalation</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notification_of_Support_Escalation_for_CS_CE</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_EH_SP_group_about_severity</fullName>
        <ccEmails>ehsp-support@pivotal.io.notify</ccEmails>
        <ccEmails>global-csr@pivotal.io.notify</ccEmails>
        <description>Notification to EH/SP group about severity</description>
        <protected>false</protected>
        <recipients>
            <recipient>abyrne@pivotal.io</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mtsang2@pivotal.io</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pdang@pivotal.io</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notification_for_EH_SP_and_severity</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_escalation_group_for_severity_1</fullName>
        <ccEmails>gss-escalation@pivotal.io.notify</ccEmails>
        <ccEmails>gss-ce-managers@pivotal.io.notify</ccEmails>
        <ccEmails>global-csr@pivotal.io.notify</ccEmails>
        <description>Notification to escalation group for severity 1</description>
        <protected>false</protected>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notification_for_case_with_severity1</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Contact</fullName>
        <description>Notify Case Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Comment_Notification_for_case_contact</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_of_assignment_Alert</fullName>
        <description>Notify Case Owner of assignment Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Case_Owner_of_assignment_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_of_comment_update_alert</fullName>
        <description>Notify Case Owner of comment update alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Executive</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Anchor</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Case Handoff</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Engineer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Service Representative</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Support Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Designated Support Engineer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Engagement Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Escalation Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Management</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>PCFS</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>PDEs</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Platform Architect</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Support Product Manager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Training Coordinator</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Case_Owner_of_comment_update</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Owner_of_reopened_ticket</fullName>
        <description>Notify Case Owner of reopened ticket</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Case_Owner_of_reopened_ticket</template>
    </alerts>
    <alerts>
        <fullName>Notify_Queue_of_Updated_Unassigned_Ticket_Data_Support</fullName>
        <description>Notify Queue of Updated Unassigned Ticket - Data Support</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Queue_of_Updated_Unassigned_Ticket_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Queue_of_Updated_Unassigned_Ticket_GSS_Escalations</fullName>
        <description>Notify Queue of Updated Unassigned Ticket - GSS Escalations</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Queue_of_Updated_Unassigned_Ticket_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Queue_of_Updated_Unassigned_Ticket_Gem_Support</fullName>
        <description>Notify Queue of Updated Unassigned Ticket - Gem Support</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Notify_Queue_of_Updated_Unassigned_Ticket_Template</template>
    </alerts>
    <alerts>
        <fullName>PWS_Email_Response_Internal_Alert</fullName>
        <description>PWS Email Response - Internal Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>PWS_Support</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/PWS_Email_Response_Internal_Template</template>
    </alerts>
    <alerts>
        <fullName>PoC_Email_Ticket_Alert</fullName>
        <description>PoC Email Ticket Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/PoC_Email_Ticket</template>
    </alerts>
    <alerts>
        <fullName>Request_for_Escalation_Management_Engagement</fullName>
        <ccEmails>escalation-management@pivotal.io.scdev</ccEmails>
        <description>Request for Escalation Management Engagement</description>
        <protected>false</protected>
        <recipients>
            <recipient>amit.bz.kumar@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>escalationmanager.test@pivotal.io</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Request_Update</template>
    </alerts>
    <alerts>
        <fullName>Survey_Email</fullName>
        <description>Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support.scqa@pivotal.io</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Support/Survey_Email_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Request_Update_Value_change</fullName>
        <field>Requestupdate__c</field>
        <literalValue>0</literalValue>
        <name>Request Update Value change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalation_Accept_Time</fullName>
        <field>Escalation_Accept_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Escalation Accept Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Escalation_Request_Time</fullName>
        <field>Escalation_Request_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Escalation Request Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Up</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Up</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>EU_Safe_Harbour</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_To_SP_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Special_Practices_CSR</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner To SP Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Solved_Time_on_Case</fullName>
        <description>used to update casesolved time field</description>
        <field>Case_solved_time__c</field>
        <formula>Now()</formula>
        <name>Update Solved Time on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Closed</fullName>
        <description>Change Status of case to closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updatespecialhandeling</fullName>
        <description>this field update will set Case: Special Handling to: Special Practices (US Citizen, US Soil)</description>
        <field>Special_Handling_Type__c</field>
        <literalValue>Special Practices (US Citizen, US Soil)</literalValue>
        <name>updatespecialhandeling</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Automated notification trigger</fullName>
        <actions>
            <name>Automated_notification_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(
(AND(InboundEmailAlias__c!=null,OR(ISNEW(),ISCHANGED(InboundEmailAlias__c)),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c),
AND( InboundEmailAlias__c !=&apos;federation-support.scqa@pivotal.io&apos;,
InboundEmailAlias__c != &apos;poc-support.scqa@pivotal.io&apos;,
InboundEmailAlias__c != &apos;customer-service.scqa@pivotal.io&apos;,
InboundEmailAlias__c != &apos;gss-escalations.scqa@pivotal.io&apos;)
)),(AND(ISNEW(),ISPICKVAL( Origin , &apos;Email&apos;) , ParentId!=NULL)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case-Special Handling field on case to%3A Special Practices %28US Citizen%2C US Soil%29</fullName>
        <actions>
            <name>updatespecialhandeling</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This work flow is used to update Case: Special Handling to:  Special Practices (US Citizen, US Soil)</description>
        <formula>or( (isnew()&amp;&amp;OwnerId=$Label.Special_Practices_CSR),(ischanged(OwnerId)&amp;&amp;OwnerId =$Label.Special_Practices_CSR))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change of Request Update</fullName>
        <actions>
            <name>Email_notification_to_the_CSR_CE_team_that_an_Update_Request_was_made</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_notification_to_the_user_who_requested_update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Requestupdate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Request_Update_Value_change</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Comment Notification</fullName>
        <actions>
            <name>Notify_Case_Contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(
  ISCHANGED(Comments__c), 
  Contact.HasOptedOutOfEmail  = FALSE,
ContactId &lt;&gt; $User.ContactId,
CONTAINS(Comments__c, &apos;AllUsers&apos;)
   
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Service Email Ticket - pivotal%2Eio</fullName>
        <actions>
            <name>Customer_Service_Email_Ticket_pivotal_io_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(InboundEmailAlias__c!=null,ISCHANGED(InboundEmailAlias__c),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c) ,  InboundEmailAlias__c =&apos;customer-service.scqa@pivotal.io&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMC Federation Email Ticket</fullName>
        <actions>
            <name>EMC_Federation_Email_Ticket_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(InboundEmailAlias__c!=null,ISCHANGED(InboundEmailAlias__c),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c), InboundEmailAlias__c =&apos;federation-support.scqa@pivotal.io&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Accept Time</fullName>
        <actions>
            <name>Set_Escalation_Accept_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Escalation_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Escalation Request Time</fullName>
        <actions>
            <name>Request_for_Escalation_Management_Engagement</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Escalation_Request_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Escalation_Management_Escalation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Internal notification for Support Escalations</fullName>
        <actions>
            <name>Internal_notification_for_Support_Escalations</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notification_to_CS_CE_about_Support_Escalation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(InboundEmailAlias__c!=null,ISCHANGED(InboundEmailAlias__c),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c) , InboundEmailAlias__c=&apos;gss-escalations.scqa@pivotal.io&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Move Case Solved To Closed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Solved</value>
        </criteriaItems>
        <description>System to move a case to Closed status (Read only) 7 days after a ticket has moved to solved status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notification for EH%2FSP with severity</fullName>
        <actions>
            <name>Notification_to_EH_SP_group_about_severity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Special_Handling__c</field>
            <operation>equals</operation>
            <value>Executive Handling (Non-BRICE)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Special_Handling__c</field>
            <operation>equals</operation>
            <value>Special Practices (US Citizen,US Soil)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification for cases through EH%2FSP email escalation channel</fullName>
        <actions>
            <name>Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Origin , &apos;Email&apos;) , InboundEmailAlias__c = &apos;ehsp-support.scqa@pivotal.io&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification for escalation group for severity1</fullName>
        <actions>
            <name>Notification_to_escalation_group_for_severity_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Severity 1 - Critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Special_Handling__c</field>
            <operation>notEqual</operation>
            <value>Executive Handling (Non-BRICE)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Special_Handling__c</field>
            <operation>notEqual</operation>
            <value>Special Practices (US Citizen,US Soil)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner of assignment</fullName>
        <actions>
            <name>Notify_Case_Owner_of_assignment_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId)&amp;&amp;  OwnerId  &lt;&gt; $User.Id</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner of comment update</fullName>
        <actions>
            <name>Notify_Case_Owner_of_comment_update_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 
ISCHANGED(Comments__c), 
Contact.HasOptedOutOfEmail = FALSE, 
OwnerId &lt;&gt; $User.Id

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Case Owner of reopened ticket Trigger</fullName>
        <actions>
            <name>Notify_Case_Owner_of_reopened_ticket</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED( Status ), 
				 OwnerId &lt;&gt; $User.Id, 
				 ISPICKVAL(Status ,&apos;Open&apos;) 
			)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Queue of Updated Unassigned Ticket - Data Support</fullName>
        <actions>
            <name>Notify_Queue_of_Updated_Unassigned_Ticket_GSS_Escalations</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( 
  NOT(ISPICKVAL( Status , &apos;Solved&apos;)) ,
      ISCHANGED( Comments__c) , 
      Owner:Queue.DeveloperName =&apos;Customer_Engineers&apos;,
     OR(
        ISPICKVAL(Products__c , &apos;Pivotal VRP&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal Command Center&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal Chorus&apos;),
        ISPICKVAL(Products__c , &apos;MADlib&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal GPText&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal HD&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal Greenplum&apos;),
        ISPICKVAL(Products__c , &apos;Open Source Redis&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal Greenplum Command Center&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal HDP&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal HDB&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal R&apos;),
        ISPICKVAL(Products__c , &apos;Open Source PostgreSQL&apos;),
        ISPICKVAL(Products__c , &apos;Datometry Workload Manager&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal Greenplum Chorus&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal GemFire&apos;),
        ISPICKVAL(Products__c , &apos;Pivotal GemFire XD&apos;)


))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Queue of Updated Unassigned Ticket - Support Escalations</fullName>
        <actions>
            <name>Notify_Queue_of_Updated_Unassigned_Ticket_Data_Support</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( NOT(IsPickval(Status,&apos;Solved&apos;)),
								 IsChanged(Comments__c),
								 Owner:Queue.DeveloperName  =&apos;Support_Escalation&apos;		
				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PWS Email Response - Internal Trigger</fullName>
        <actions>
            <name>PWS_Email_Response_Internal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(InboundEmailAlias__c!=null,ISCHANGED(InboundEmailAlias__c),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c) ,   
OR(
  InboundEmailAlias__c  = &apos;pws-account.scqa@pivotal.io&apos;,
  InboundEmailAlias__c  = &apos;pws-feedback.scqa@pivotal.io&apos;,
  InboundEmailAlias__c = &apos;pws-support.scqa@pivotal.io&apos;,
 InboundEmailAlias__c = &apos;support@run.pivotal.io&apos;
)
 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PoC Email Ticket Trigger</fullName>
        <actions>
            <name>PoC_Email_Ticket_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(InboundEmailAlias__c!=null,ISCHANGED(InboundEmailAlias__c),InboundEmailAlias__c != PRIORVALUE(InboundEmailAlias__c) , InboundEmailAlias__c=&apos;poc-support.scqa@pivotal.io&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Route EHSP Cases To SP Queue</fullName>
        <actions>
            <name>Update_Case_Owner_To_SP_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OwnerId =&apos;00G29000000ewHn&apos;,  ISPICKVAL(Origin,&apos;Email&apos;),  IsESHP__c =TRUE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route EUSafe Cases To EU Queue</fullName>
        <actions>
            <name>Update_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Special_Handling__c</field>
            <operation>equals</operation>
            <value>EU - Safe Harbour</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Solved Time on Case</fullName>
        <actions>
            <name>Update_Solved_Time_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>used to update casesolved time field</description>
        <formula>AND(ISCHANGED(Status),ispickval(Status,&apos;solved&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Workflow for creation of case</fullName>
        <actions>
            <name>Automated_notification_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( CaseNumber &lt;&gt;Null, 
OR( ISPICKVAL(Origin, &apos;Phone&apos;) ,ISPICKVAL(Origin, &apos;Service Cloud&apos;),ISPICKVAL(Origin, &apos;Community&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
