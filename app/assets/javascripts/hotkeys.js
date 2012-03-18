var g_mark = false;

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

		$(document).bind('keydown', 's', function(e) {
			$(".entry.current").toggle("span.item-star", "star-inactive", set_shared_status); return false;
		});

		$(document).bind('keydown', 'n', function(e) {
			$(".entry.current").toggle("span.share-with-note", "share-with-note-inactive", set_shared_with_note_status); return false;
		});

		$(document).bind('keydown', 'o', function(e) {
			if ($(".entry.current").length > 0) {
				window.open($(".entry.current").find(".entry-title-link").attr("href"), '_blank');
			};
		});
		
		$(document).bind('keydown', 'g', function(e) {
			g_mark = true;
			setTimeout("g_mark = false", 1000);
		});
		
		$(document).bind('keydown', 'a', function(e) {
			if (g_mark) {
				$("#all-items-link").click();
				g_mark = false;
			}
		});
		
		$(document).bind('keydown', 's', function(e) {
			if (g_mark) {
				$("#shared-items-link").click();
				g_mark = false;
			}
		});
		
		$(document).bind('keydown', 'shift+I', function(e) {
			if (INSTAPAPER.username.length > 0) {
				$.ajax(
					{url: "https://www.instapaper.com/api/add", type: "GET", dataType: "jsonp", crossDomain: true, 
						data: {jsonp: "handle_instapaper", username: INSTAPAPER.username, password: INSTAPAPER.password, 
							url: $(".entry.current .entry-title-link").attr("href")}
					});
			}
		});
	};	
});

var handle_instapaper = function() {
	broadcast("Successfully saved entry to Instapaper!");
};