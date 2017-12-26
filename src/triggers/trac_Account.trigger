trigger trac_Account on Account (after insert, after update) {

	if(Trigger.isAfter && Trigger.isInsert) {
		trac_Account.createAndUpdatePartnershipAfterAccountInsert(trigger.new);

	} 
	if(Trigger.isAfter && Trigger.isUpdate) {
		trac_Account.createAndUpdatePartnershipAfterAccountInsert(trigger.new);
	}

}