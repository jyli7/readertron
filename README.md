- rename Post class to Entry

2. Reader interface.
	a. Two-pane view, left hand side with subscriptions, right with viewer.
		(At first, one subscription at a time, using an URL param like "/reader/?feed_id=13")
		i. Read and unread.
			A. Marking as read as you read.
			B. Marking as unread.
----> FOCUS ON THESE FIRST:
		ii. Keyboard shortcuts.
		iii. Scrolling.
			A. Snap to top of view on click.
			B. Infinite scroll pulls in new posts.
	c. AJAX-ify the pane.
	d. where that big SUBSCRIBE button was, put a COMPOSE POST button

- date should be "n minutes ago" if super recent

- feed folders

## FEATURES

* Admin interface.
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
	- encourage original posts
	- send e-mail to people with summary of what they've been missing, new content, etc.

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