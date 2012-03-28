## Readertron

Readertron is an attempt to revive the old "social" Google Reader -- see particularly my [lament](#lament) below -- and a fun experiment in building useful software.

## Todos

### Core / New Features
- Editing Quickposts
- Previewing Quickposts
- Polling for shared counts every 30s or so, and flashing on new content.
- Comment / Quickpost / Note view, in reverse chronological order. Load them all. Call it the "thought stream."
- Starring posts.
- Search.
	- Returns infinitely-scrollable results in the #entries div, but using a different partial, this one with a snippet view.
	- The opened up version has the terms highlighted.
	- "Back to search results" link.
- Collapsed view.
- One-click evernote integration.
- Subscribe to friends' feeds that you might like (that you don't already have).
- Gamifying:
	- Surfacing long comments.
	- Ability to rank comments? (+1 for "best of").
	- Most shared.
	- Most shared from feed.
	- Be especially fond of finds that come in via the bookmarklet.
	- Producer vs. consumpto (ratio of stories shared to read).
	- Encourage original posts.
	- Send e-mail to people with summary of what they've been missing, new content, etc.
- The notion of circles.

### Feeds, Fetching
- Duplicate posts.
- Keep an eye on feeds that haven't gotten a post in a while.
- Is Feedzirra not getting new posts quickly enough? How does Google stay so up to date?
- Let's profile feeds to make sure we're getting shit for new ones (think jsomers.tumblr.com), fetching for all of them, pruning true failures, retrying on spurious failures, etc.
- Parsing relative URLs within posts, as in post 62 (in production).
	- 400s of content using relative URLs / strip harmful or disruptive content.

### Refactoring
- Abstract out an API.
- Backbone, mustache templates for the front end?
- CSS -> SASS, and reusing rules.

### Performance, Ops
- Fix the logging situation. Maybe use Airbrake?
- Semantic joins, things like "subscribers," and AM's idea of dumping scopes on the associations themselves.
- A queue to send e-mails after comments, rather than doing it inline.
- Database backups.
- /entries less than 1s.
- Nginx speed tweaks.
	- PCRE or whatever for compressing assets.
- :include and such on joins and lookups (Subscriptions and Feeds, for instance).

### Bookmarklet
- Chip had problem with the bookmarklet?
- Unsharing bookmarklet posts.
	- Validate against duplicate bookmarklet posts?
- Sharing YouTube videos via the bookmarklet.

### UI, UX, Style
- j & k & c & o on the /mine page.
- The first post is being marked as read. (Silber)
- Linkify URLs in comments and share-notes.
- The overlap of the reading area onto the subscriptions pane.
- "1 new items."
- Meta page input box widths on firefox.
- Meta page input box labels, vs. placeholders.
- Feed links on /\_entry and /\_share should link to those feeds.
- Emails should come from "Readertron", not "notifications."
- Blue current bar becomes gray with read.
- Keyboard shortcut "?" help menu.
- Reordering feeds through drag-and-drop.
- Close the "share with note" thing right after you click it, and broadcast the message then, too.
- Also broadcast on regular shares.
- Gravatars for users (I could probably pull them over myself), and a more Reader-like share-with-note style.
- Scroll trigger still not smart enough?
- Prevent you from leaving the page if you've got "unsaved changes" (i.e., a pending AJAX request that's not a poll).
- The David Brooks feed and images creeping in.

### Reader UX
- De-duplicate shared posts and those posts in the regular feed.
- Look at shared items by feed, or vice versa.

### User Settings
- Option on users for turning off the "I commented too" type of notification.
- Google login integration, API, Recommended Items?

### CloudMailin
- Rescue out of of the controller action, send a report with AdminMailer.
- 500 out and instruct CloudMailin to reply to sender.

<a name="lament"/>
## Google Reader Lost: A Lament

I haven't forgotten about Google Reader. Every so often, in fact -- and now is one of those moments -- I feel this crazy maniacal rage about what we've lost. God it used to be wonderful.

I no longer read as much, think as much, or write as much. 

There are certain people I no longer think *of* as much. It was weird the way a daily stream of shares would seem to feed friendships just like a real conversation; I felt "in touch" with a great wide circle that way.

Is it perverse that I don't care hardly as much about the articles I read without the Reader crew to share them to?

It's amazing how the littlest friction can torpedo a user experience. That "Note in Google Reader" bookmarklet was a difference-maker. The one-click share in Reader was a difference-maker.

It was such a thrill to be able to rely on the fact that a small group of certain people would know what you were talking about when you referenced some "share" you made a couple of weeks ago. It was like the lot of us lived in, or dabbled in, the others' mental context.

I'm not just being nostalgic. I thought this way about Reader while we were using it.

What Reader reminded me most of was this idea in Ender's Game of that online forum where these kids could play the role of "Locke" and "Demosthenes" in a forum of consequence. Reader felt strangely like a forum of consequence. What an outlet!

When you read these essays or e-mails in the early days of the Internet where people imagined the best of what it would be, it always, ALWAYS sounds exactly like what we had with Reader.

I know that "what we had" could exist in other software. Of course the software is incidental to the group and its behavior, and millions of other thriving groups thrive elsewhere. It could be IRC, e-mail, usenet, a more traditional forum, other RSS aggregators, etc. But the community I gave a shit about happened to use Google Reader and that community, for totally reasonable reasons, went up in smoke the moment the software changed. We may never get it back.

How terribly terribly sad.