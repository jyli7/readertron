1. Central job for fetching feeds, to be run every 10 minutes.
	a. Fetch and parse feeds.
	b. Hydrate feeds that need hydrating.
	c. Retry queue?
2. Reader interface.
	a. Two-pane view, left hand side with subscriptions, right with viewer.
		(At first, one subscription at a time, using an URL param like "/reader/?feed_id=13")
		i. Read and unread.
			A. Marking as read as you read.
			B. Marking as unread.
		ii. Keyboard shortcuts.
		iii. Scrolling.
			A. Snap to top of view on click.
			B. Infinite scroll pulls in new posts.
	c. AJAX-ify the pane.

## FEATURES

* Admin interface.
3. Reading: an interface mostly like Reader.
	- an "all posts" view
	- viewing posts by each feed
	- posts are highlighted and keyboard shortcuts are scoped to that post
4. Sharing a post.
	- You can see the post-shares of everyone you follow.
	- You can add a note to that post.
6. API to create a post-share from URL, user (session?), and HTML content.
7. E-mail notifications.
8. Comment creation via e-mail replies.
9. One-click Instapaper integration.
10. "n <note>" integration via the API.
11. Print individual post.
11.5 Subscribing bookmarklet?
12. Gamifying:
	- surfacing long comments
	- ability to rank comments? (+1 for "best of")
	- most shared
	- most shared from feed
	- be especially fond of finds that come in via the bookmarklet
	- producer vs. consumpto (ratio of stories shared to read)

## MODELS

Feed
Post
	- feed_id
User
	- email
	- [password]
Following
	- followed_user_id
	- following_user_id
PostShare
	- user_id
	- post_id
	- note (text)
Comment
	- user_id
	- post_share_id
	- content (text)
Subscription
	- user_id
	- feed_id