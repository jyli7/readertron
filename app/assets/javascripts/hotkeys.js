$(document).ready(function() {
	if ($("#panes").length > 0) {
		$(document).bind('keydown', 'j', function(e) {
			next_post(+1); return false;
		});

		$(document).bind('keydown', 'k', function(e) {
			next_post(-1); return false;
		});

		$(document).bind('keydown', 'm', function(e) {
			$(".entry.current").toggle("span.read-state", "read-state-kept-unread", mark_as_read); return false;
		});

		$(document).bind('keydown', 'h', function(e) {
			$(".entry.current").toggle("span.item-star", "star-inactive", set_shared_status); return false;
		});

		$(document).bind('keydown', 'n', function(e) {
			$(".entry.current").toggle("span.share-with-note", "share-with-note-inactive", set_shared_with_note_status); return false;
		});

		$(document).bind('keydown', 'v', function(e) {
			if ($(".entry.current").length > 0) {
				window.open($(".entry.current").find(".entry-title-link").attr("href"), '_blank');
			};
		})
	};	
});