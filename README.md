1. pretty up user, signup, etc., pages (onboarding UI -- what to do first once you've hit the /subscriptions page, etc.)
- don't require selection on bookmarklet.

- settings-type link to the /subscriptions page.

deploy
- cron job in separate thread to poll for new rss data

- option on users for turning off the "I commented too" type of notification.
- nokogiri parser segfault?
- "1 new items"
- refactor regular vs. shared count maintenance code.
- modeling, controllers, separation of concerns
- 400s of content using relative URLs / strip content of bad shit.
- windows bookmarklet broken?
- editing quickposts
- quickposts preview
- keyboard shortcut "?" menu.
- a comment stream view, with links to each of the posts.
- starring posts
- search
	- returns infinitely-scrollable results in the #entries div, but using a different partial, this one with a snippet view.
	- the opened up version has the terms highlighted.
	- "back to search results" link.
- prettier submit buttons and things
- collapsed view
- sassify CSS
- replying in comments
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