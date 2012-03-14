$(document).ready(function() {
	$("#subscriptions li").click(function() {
		var feed_id = $(this).split_id();
		fetch_entries(feed_id);
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
});

$.fn.split_id = function() {
	return this.attr("id").split("-")[1];
};

$.fn.snap_to_top = function() {
	$.scrollTo(this, {offset: -10});
};

$.fn.notch = function(n) {
	var current_count = parseInt(this.text().replace(/[^0-9]/g, ""));
	this.text(this.text().replace(/[0-9]+/, current_count + n))
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

var fetch_entries = function(feed_id) {
	$("#loading-area-container").show();
	$.get("/reader/entries", {"feed_id": feed_id}, function(ret) {
		$("#entries").html(ret);
		$("#loading-area-container").hide();
		$.scrollTo($("#entries"), {offset: -50});
	});
}