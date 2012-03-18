- nokogiri parser segfault?

- 400s of content using relative URLs / strip content of bad shit.

- "1 new items"

- pretty up user, signup, etc., pages

- refactor regular vs. shared count maintenance code.
- show who shared a post in the shared views
- sort out "My Shared Items" stuff: how to render the posts (as shares?), how to deal with unreads.

- modeling, controllers, separation of concerns

deploy
- cron job in separate thread to poll for new rss data

- windows bookmarklet broken?
- scrolling to the bottom of the subscriptions list

- edit quickposts
- a comment stream view, with links to each of the posts.
- starring posts
- search
	- returns infinitely-scrollable results in the #entries div, but using a different partial, this one with a snippet view.
	- the opened up version has the terms highlighted.
	- "back to search results" link.
- collapsed view
- sassify CSS
- comment creation via e-mail replies.
- de-duplicate shared posts and those posts in the regular feed.
- look at shared items by feed, or vice versa
- one-click evernote integration.
- fancy look for the "Note in Readertron" bookmarklet link
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