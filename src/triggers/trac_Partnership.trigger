trigger trac_Partnership on Partnership__c (after insert, after update) {

	if(Trigger.isAfter && Trigger.isInsert) {
		trac_Partnership.updateAccountProgramWithNull(trigger.new);
	}
}