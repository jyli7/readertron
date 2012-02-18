## FEATURES

1. RSS feeds: you give an URL, it subscribes you to a feed.
2. RSS feeds: you import a dump from Google Reader and it subscribes you to all of those feeds.
3. Reading: an interface mostly like Reader.
	- an "all posts" view
	- viewing posts by each feed
	- posts are highlighted and keyboard shortcuts are scoped to that post
4. Sharing a post.
	- You can see the post-shares of everyone you follow.
	- You can add a note to that post.
5. Each user gets his own view of the system, obviously.
6. API to create a post-share from URL, user (session?), and HTML content.
7. E-mail notifications.
8. Comment creation via e-mail replies.
9. One-click Instapaper integration.
10. "n <note>" integration via the API.
11. Print individual post.

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
UserFeedSubscription
	- user_id
	- feed_id