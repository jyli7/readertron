- KOTTKE feed?
- Bactra.org feed?
- deduplicating feeds!
- let's profile feeds to make sure we're getting shit for new ones (think jsomers.tumblr.com), fetching for all of them, pruning true failures, retrying on spurious failures, etc.

- chip had problem with bookmarklet?
- "c" comment hotkey
- unsharing bookmarklet posts
	- validate against duplicate bookmarklet posts?
- "My Shared Items" feed generally

- comment on a post sends e-mail to yourself?
- blue current bar becomes gray with read.
- close the "share with note" thing right after you click it, and broadcast the message then, too.
- also broadcast on regular shares.
- update your share count when you share something.
- polling for shared counts every 30s or so.
- subscribe to friends' feeds that you might like (that you don't already have).

- gravatars for users (I could probably pull them over myself), and a more Reader-like share-with-note style.

- db backup

- sharing YouTube videos via the bookmarklet.
- first post being marked as read. (silber)
- meta page input box widths on firefox
- /entries less than 1s
- scroll trigger still not smart enough?
- timestamps on posts are in the wrong time zone?

- abstract out an API

- prevent you from leaving the page if you've got "Unsaved changes" (i.e., a pending AJAX request that's not a poll)

- nginx speed configs
- actually using .count when counts are what we need
- caching?
- more memory?
- :include and such on joins and lookups (Subscriptions and Feeds, for instance)
- "feeds lots of people are subscribed to on /subscriptions"
- a little "success" notice after you've submitted your OPML.
- relative URLs, as in post 62 (in production)
	- 400s of content using relative URLs / strip content of bad shit.
- bommarito feed fucking up the styling
- the david brooks feed and images creeping in
- norvig feed count out of whack on my feeds?
- feed links on /\_entry and /\_share should skip to those feeds.
- settings-type link to the /subscriptions page, and the ability to add a feed, remove them, etc.
- editing quickposts
- quickposts preview
- editing the notes on a post
- keyboard shortcut "?" menu.

- option on users for turning off the "I commented too" type of notification.
- nokogiri parser segfault?
- this very annoying assets management shit w/ git across environments
- PCRE or whatever for compressing assets in nginx.
- speeding up the interval at which we call Feed.refresh.
- "1 new items"
- refactor regular vs. shared count maintenance code.
- modeling, controllers, separation of concerns
- bookmarklet broken on FF on windows?
- a comment stream view, with links to each of the posts.
- starring posts
- search
	- returns infinitely-scrollable results in the #entries div, but using a different partial, this one with a snippet view.
	- the opened up version has the terms highlighted.
	- "back to search results" link.
- collapsed view
- sassify CSS
- replying in comments
- comment creation via e-mail replies.
- de-duplicate shared posts and those posts in the regular feed.
- look at shared items by feed, or vice versa
- one-click evernote integration.
- google login integration. API?
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