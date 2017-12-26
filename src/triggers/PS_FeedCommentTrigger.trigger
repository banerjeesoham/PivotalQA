trigger PS_FeedCommentTrigger on FeedComment (After Insert, After Update) {
    FeedItemCommentTriggerHandler feedItemObj = new FeedItemCommentTriggerHandler ();
    feedItemObj.feedCommentMethod();
}