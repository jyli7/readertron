- currentize items as you scroll (compare window.scrollTop() with the element's scrollTop)

- handle feed favicons on CRUD

- refactor regular vs. shared count maintenance code.
- show who shared a post in the shared views
- sort out "My Shared Items" stuff: how to render the posts (as shares?), how to deal with unreads.

- sorter broken in firefox. (missing moz css declaration?)

- refresh ALL posts on feed fetch (and propagate to shared copies)
- cron job in separate thread to poll for new rss data

- pretty up the bookmarklet, and add useful information like title, and some sense of the post preview.

- where that big subscribe button was, put a "QuickPost" button. highlight those posts in red or something. shows up in a person's share feed.

- "1 new items"

- e-mail notifications about comments on your shared items, or on items you've commented on.

- 400s of content using relative URLs

- modeling, controllers, separation of concerns
- pretty up user, signup, etc., pages

deploy

- starring posts
- search
- comment creation via e-mail replies.
- de-duplicate shared posts and those posts in the regular feed.
- one-click evernote integration.
- admin interface.
- "n <note>" integration via the api.
- print individual post.
- gamifying:
	- surfacing long comments
	- ability to rank comments? (+1 for "best of")
	- most shared
	- most shared from feed
	- be especially fond of finds that come in via the bookmarklet
	- producer vs. consumpto (ratio of stories shared to read)
	- encourage original posts
	- send e-mail to people with summary of what they've been missing, new content, etc.
- the notion of circles