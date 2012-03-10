$(document).ready(function() {
	$(".entry").click(function() {
		if (!$(this).hasClass("current")) {
			set_as_current_entry(this);
		};
	});
	if ($("#panes").length > 0) {
		$(document).bind('keydown', 'j', function(e) {
			next_post(1); return false;
		});

		$(document).bind('keydown', 'k', function(e) {
			next_post(-1); return false;
		});
	
		$(document).bind('keydown', 'm', function(e) {
			toggle_read_status(".entry.current"); return false;
		});
	
		$(document).bind('keydown', 's', function(e) {
			toggle_shared_status(".entry.current"); return false;
		});
	
		$(document).bind('keydown', 'shift+s', function(e) {
			toggle_email_status(".entry.current"); return false;
		});
	
		$(document).bind('keydown', 'v', function(e) {
			if ($(".entry.current").length > 0) {
				window.open($(".entry.current").find(".entry-title-link").attr("href"), '_blank');
			};
		})
	};
	
	$(".read-state").click(function() {
		toggle_read_status($(this).closest(".entry"));
		return false;
	});
	
	$(".item-star").click(function() {
		toggle_shared_status($(this).closest(".entry"));
		return false;
	});
	
	$(".entry-actions .email").click(function() {
		toggle_email_status($(this).closest(".entry"));
		return false;
	});
	
	$("#subscriptions li").click(function() {
		var feed_id = $(this).attr("id").split("-")[1];
		window.location = "/?feed_id=" + feed_id;
		$("#subscriptions li").removeClass("selected");
		$(this).addClass("selected");
		return false;
	});
	
	$("#subscriptions").slimScroll({
		height: "800px",
		wheelStep: 5,
		allowPageScroll: false
	});
	
	$(".item-body a").click(function() {
		window.open($(this).attr("href"), '_blank');
		return false;
	});
	
	$(".cancel-share-with-note").click(function() {
		toggle_email_status($(this).closest(".entry"));
		return false;
	});
	
	$(".card-share-with-note input[type=submit]").click(function() {
		share_with_note($(this).closest(".entry"));
		return false;
	});
});

function set_as_current_entry(entry) {
	$(".entry").removeClass("current");
	$(entry).addClass("current");
	if (!$(entry).find("span.read-state").hasClass("read-state-kept-unread") && !$(entry).hasClass("dirty")) {
		$.post("/reader/mark_as_read", {"post_id": $(entry).attr("post_id")}, function(ret) {
			$("#subscription-" + ret.feed_id).find(".unread_count").text("(" + ret.unread_count + ")");
			decrement("#total_unread_count");
			$(entry).addClass("dirty");
		});
	};
	snap_to_top(entry);
};

function snap_to_top(div) {
	$.scrollTo($(div), {offset: -10});
};

function next_post(offset) {
	if ($(".entry.current").length == 0) {
		next_post_index = 0;
	} else {
		next_post_index = parseInt(index_for(".entry.current")) + offset;
	};
	if ($("#entry-" + next_post_index).length == 0) {
		return false;
	} else {
		set_as_current_entry($("#entry-" + next_post_index));
	}
};

function toggle_read_status(selector) {
	$span = $(selector).find("span.read-state");
	if ($span.hasClass("read-state-not-kept-unread")) {
		read_mark(selector, "unread");
	} else if ($span.hasClass("read-state-kept-unread")) {
		read_mark(selector, "read")
	};
};

function read_mark(selector, r_u) {
	$span.removeClass(r_u == "read" ? "read-state-kept-unread" : "read-state-not-kept-unread");
	$span.addClass(r_u == "read" ? "read-state-not-kept-unread" : "read-state-kept-unread");
	$.post("/reader/mark_as_" + r_u, {"post_id": $(selector).attr("post_id")}, function(ret) {
		$("#subscription-" + ret.feed_id).find(".unread_count").text("(" + ret.unread_count + ")");
		r_u == "read" ? decrement("#total_unread_count") : increment("#total_unread_count");
	});
};

function toggle_shared_status(selector) {
	var $span = $(selector).find("span.item-star");
	if ($span.hasClass("star-active")) {
		share_set(selector, "unshare");
	} else if ($span.hasClass("star-inactive")) {
		share_set(selector, "share")
	};
};

function share_set(selector, s_s) {
	var $span = $(selector).find("span.item-star");
	$span.removeClass(s_s == "share" ? "star-inactive" : "star-active");
	$span.addClass(s_s == "share" ? "star-active" : "star-inactive");
	$.post("/reader/post_" + s_s, {"post_id": $(selector).attr("post_id")}, function(ret) {
		// Do something?
	});
};

function toggle_email_status(selector) {
	var $span = $(selector).find("span.email");
	if ($span.hasClass("email-active")) {
		email_set(selector, "unemail");
	} else if ($span.hasClass("email-inactive")) {
		email_set(selector, "email")
	};
};

function email_set(selector, r_u) {
	var $span = $(selector).find("span.email");
	$span.removeClass(r_u == "email" ? "email-inactive" : "email-active");
	$span.addClass(r_u == "email" ? "email-active" : "email-inactive");
	if (r_u == "email") {
		$(selector).find(".card-share-with-note").show();
		$(selector).find(".card-share-with-note").find("textarea").focus();
	} else {
		$(selector).find(".card-share-with-note").hide();
		$.post("/reader/post_unshare", {"post_id": $(selector).attr("post_id")});
	};
};

function share_with_note(entry) {
	var note_content = $(entry).find("textarea[name=note_content]").val();
	var post_id = $(entry).attr("post_id");
	$.post("/reader/share_with_note", {"post_id": post_id, "note_content": note_content}, function(ret) {
		$(entry).find(".card-share-with-note").hide();
	});
};

function index_for(entry) {
	return $(entry).attr("id").split("-")[1];
};

function increment(div) {
	var current_count = parseInt($(div).text());
	$(div).text(current_count + 1);
};

function decrement(div) {
	var current_count = parseInt($(div).text());
	$(div).text(current_count - 1);
};