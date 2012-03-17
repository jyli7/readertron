$(document).ready(function() {
	
	$("#alert").fadeOut(3000);
	
	$("#subscriptions li").click(function() {
		POST_FILTERS.feed_id = $(this).split_id();
		fetch_entries();
		$("#subscriptions li, #subscriptions h3").removeClass("selected");
		$(this).addClass("selected");
		return false;
	});
	
	$("#subscriptions h3").click(function() {
		POST_FILTERS.feed_id = $(this).attr("feed_id");
		$("#subscriptions li").removeClass("selected");
		$("#subscriptions h3").removeClass("selected");
		$(this).addClass("selected");
		fetch_entries();
		return false;
	});

	$("#subscriptions").slimScroll({
		height: "800px",
		wheelStep: 5,
		allowPageScroll: false
	});

	$(".item-body a").live("click", function() {
		window.open($(this).attr("href"), '_blank');
		return false;
	});
	
	$(".view-all-items").live("click", function() {
		POST_FILTERS.items_filter = "all";
		$(".menu-button-caption").text("All items");
		fetch_entries();
	});
	
	refresh_unread_counts();
	refresh_shared_unread_counts();
});

$.fn.split_id = function() {
	return this.attr("id").split("-")[1];
};

$.fn.snap_to_top = function() {
	$.scrollTo(this, {offset: -50});
};

$.fn.get_int = function() {
	return parseInt(this.text().replace(/[^0-9]/g, ""));
};

$.fn.replace_int = function(n) {
	this.text(this.text().replace(/[0-9]+/, n));
};

$.fn.notch = function(n) {
	this.replace_int(this.get_int() + n);
};

var next_post = function(offset) {
	if ($(".entry.current").length == 0) {
		next_post_index = 0;
	} else {
		next_post_index = parseInt($(".entry.current").split_id()) + offset;
	};
	if ($("#entry-" + next_post_index).length == 0) {
		return false;
	} else {
		$("#entry-" + next_post_index).set_as_current_entry();
	}
};

var fetch_entries = function() {
	$("#loading-area-container").show();
	$.get("/reader/entries", POST_FILTERS, function(ret) {
		$("#entries").html(ret);
		$("#loading-area-container").hide();
		$.scrollTo($("#entries"), {offset: -50});
		refresh_unread_counts();
		refresh_shared_unread_counts();
	});
};

var refresh_unread_counts = function() {
	var total_count = 0;
	for (var k in UNREAD_COUNTS) {
		var old_count = $("#subscription-" + k).find(".unread_count").get_int();
		var new_count = UNREAD_COUNTS[k];
		total_count += new_count;
		if (new_count > 0) {
			$("#subscription-" + k).addClass("unread").find(".unread_count").text("(" + new_count + ")");
		} else {
			$("#subscription-" + k).removeClass("unread").find(".unread_count").text("");
		};
	};
	var rep;
	if (POST_FILTERS.feed_id == undefined || POST_FILTERS.feed_id == "") {
		rep = total_count;
	} else if (UNREAD_COUNTS[POST_FILTERS.feed_id] == undefined) {
		rep = SHARED_UNREAD_COUNTS[POST_FILTERS.feed_id];
	} else {
		rep = UNREAD_COUNTS[POST_FILTERS.feed_id];
	};
	$("#new-items-count-hidden").text(rep);
	$("#new-items-count-visible").text(rep);
	reset_unread_or_all_width();
	$("#total_unread_count").text("(" + total_count + ")");
	$("title").text("Readertron (" + total_count + ")");
};

var refresh_shared_unread_counts = function() {
	var total_count = 0;
	for (var k in SHARED_UNREAD_COUNTS) {
		var old_count = $("#subscription-" + k).find(".unread_count").get_int();
		var new_count = SHARED_UNREAD_COUNTS[k];
		total_count += new_count;
		if (new_count > 0) {
			$("#subscription-" + k).addClass("unread").find(".unread_count").text("(" + new_count + ")");
		} else {
			$("#subscription-" + k).removeClass("unread").find(".unread_count").text("");
		};
	};
	var rep;
	if (POST_FILTERS.feed_id == undefined || POST_FILTERS.feed_id == "") {
		rep = null;
	} else if (POST_FILTERS.feed_id == "shared") {
		rep = total_count;
	} else if (SHARED_UNREAD_COUNTS[POST_FILTERS.feed_id] == undefined) {
		rep = UNREAD_COUNTS[POST_FILTERS.feed_id];
	} else {
		rep = SHARED_UNREAD_COUNTS[POST_FILTERS.feed_id];
	};
	if (rep != null) {
		$("#new-items-count-hidden").text(rep);
		$("#new-items-count-visible").text(rep);
	};
	reset_unread_or_all_width();
	$("#shared_unread_count").text("(" + total_count + ")");
};

var notch_unread_for_feed_id = function(feed_id, n) {
	UNREAD_COUNTS[feed_id] = UNREAD_COUNTS[feed_id] + n;
	refresh_unread_counts();
};

var shared_notch_unread_for_feed_id = function(feed_id, n) {
	SHARED_UNREAD_COUNTS[feed_id] = SHARED_UNREAD_COUNTS[feed_id] + n;
	refresh_shared_unread_counts();
};

var broadcast = function(msg) {
	$("#broadcast-message").text(msg).parent().show().fadeOut(3000);
};