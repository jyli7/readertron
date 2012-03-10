$(document).ready(function() {
	$(".entry").click(function() {
		if (!$(this).hasClass("current")) {
			set_as_current_entry(this);
		};
	});
	
	$(document).bind('keydown', 'j', function(e) {
		next_post(1); return false;
	});

	$(document).bind('keydown', 'k', function(e) {
		next_post(-1); return false;
	});
	
	$(document).bind('keydown', 'm', function(e) {
		toggle_read_status(".entry.current"); return false;
	});
	
	$(document).bind('keydown', 'v', function(e) {
		if ($(".entry.current").length > 0) {
			window.open($(".entry.current").find(".entry-title-link").attr("href"), '_newtab');
		};
	})
	
	$(".read-state").click(function() {
		toggle_read_status($(this).closest(".entry"));
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
		allowPageScroll: false
	});
});

function set_as_current_entry(entry) {
	$(".entry").removeClass("current");
	$("#entry-" + index_for(entry)).addClass("current");
	if (!$(entry).find("span.read-state").hasClass("read-state-kept-unread")) {
		$.post("/reader/mark_as_read", {"post_id": $(entry).attr("post_id")}, function(ret) {
			$("#subscription-" + ret.feed_id).find(".unread_count").text("(" + ret.unread_count + ")");
			decrement("#total_unread_count");
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
		$span.removeClass("read-state-not-kept-unread");
		$span.addClass("read-state-kept-unread");
		$.post("/reader/mark_as_unread", {"post_id": $(selector).attr("post_id")}, function(ret) {
			$("#subscription-" + ret.feed_id).find(".unread_count").text("(" + ret.unread_count + ")");
			increment("#total_unread_count");
		});
	} else if ($span.hasClass("read-state-kept-unread")) {
		$span.removeClass("read-state-kept-unread");
		$span.addClass("read-state-not-kept-unread");
		$.post("/reader/mark_as_read", {"post_id": $(selector).attr("post_id")}, function(ret) {
			$("#subscription-" + ret.feed_id).find(".unread_count").text("(" + ret.unread_count + ")");
			decrement("#total_unread_count");
		});
	};
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