- rename Post class to Entry
- put title of current feed up top.
- by default, subscribe you to everybody else's feed. Opt out on subscriptions page.

2. Reader interface.
	b. Post sharing!
	c. Sharing with note.
	d. Commenting on a shared post.
	e. where that big SUBSCRIBE button was, put a COMPOSE POST button. Highlight those posts in RED or something. Shows up in a person's Share feed.

- clean up and refactor a bit

## FEATURES

* Admin interface.
6. API to create a post-share from URL, user (session?), and HTML content.

7. E-mail notifications.
8. Comment creation via e-mail replies.
9. One-click Instapaper integration.
9.5 One-click Evernote integration.
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