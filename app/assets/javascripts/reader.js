$(document).ready(function() {
	$("#subscriptions li").click(function() {
		POST_FILTERS.feed_id = $(this).split_id();
		fetch_entries();
		$("#subscriptions li").removeClass("selected");
		$(this).addClass("selected");
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
		fetch_entries();
	});
});

$.fn.split_id = function() {
	return this.attr("id").split("-")[1];
};

$.fn.snap_to_top = function() {
	$.scrollTo(this, {offset: -10});
};

$.fn.notch = function(n) {
	var current_count = parseInt(this.text().replace(/[^0-9]/g, ""));
	this.text(this.text().replace(/[0-9]+/, current_count + n));
	reset_unread_or_all_width();
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
		var unread_count = $("#unread-count-dump").text();
		$("#new-items-count-hidden").text(unread_count);
		$("#new-items-count-visible").text(unread_count);
		reset_unread_or_all_width();
		$("#subscription-" + POST_FILTERS.feed_id).find(".unread_count").text("(" + unread_count + ")");
	});
}