$(document).ready(function() {
	$(".entry").click(function() {
		set_as_current_entry(this);
	});
	
	$(document).bind('keydown', 'j', function(e) {
		next_post(); return false;
	});

	$(document).bind('keydown', 'k', function(e) {
		previous_post(); return false;
	});
	
	$(document).bind('keydown', 'm', function(e) {
		toggle_read_status(); return false;
	})
});

function set_as_current_entry(entry) {
	$(".entry").removeClass("current");
	$("#entry-" + index_for(entry)).addClass("current");
	snap_to_top(entry);
};

function snap_to_top(div) {
	$.scrollTo($(div), {offset: -10});
};

function next_post() {
	next_post_index = parseInt(index_for(".entry.current")) + 1;
	set_as_current_entry($("#entry-" + next_post_index));
};

function previous_post() {
	prev_post_index = parseInt(index_for(".entry.current")) - 1;
	set_as_current_entry($("#entry-" + prev_post_index));
};

function toggle_read_status() {
	$span = $(".entry.current").find("span.read-state");
	if ($span.hasClass("read-state-not-kept-unread")) {
		$span.removeClass("read-state-not-kept-unread");
		$span.addClass("read-state-kept-unread");
	} else if ($span.hasClass("read-state-kept-unread")) {
		$span.removeClass("read-state-kept-unread");
		$span.addClass("read-state-not-kept-unread");
	};
};

function index_for(entry) {
	return $(entry).attr("id").split("-")[1];
};