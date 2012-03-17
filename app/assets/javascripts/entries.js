$(document).ready(function() {
	$(".entry").live("click", function() {
		if (!$(this).hasClass("current"))
			$(this).set_as_current_entry(true);
	});

	$(".read-state").live("click", function() {
		$(this).closest(".entry").toggle("span.read-state", "read-state-kept-unread", mark_as_read);
		return false;
	});
	
	$(".item-star").live("click", function() {
		$(this).closest(".entry").toggle("span.item-star", "star-inactive", set_shared_status);
		return false;
	});
	
	$(".entry-actions .share-with-note").live("click", function() {
		$(this).closest(".entry").toggle("span.share-with-note", "share-with-note-inactive", set_shared_with_note_status);
		return false;
	});
	
	$(".cancel-share-with-note").live("click", function() {
		$(this).closest(".entry").toggle("span.share-with-note", "share-with-note-inactive", set_shared_with_note_status);
		return false;
	});
	
	$(".card-share-with-note input[type=submit]").live("click", function() {
		$(this).closest(".entry").share_with_note();
		return false;
	});
	
	$(document).scroll(function() {
		if ($(".entry.current").length == 0 && $(window).scrollTop() > lastScrollTop) {
			$(".entry:first").set_as_current_entry(false);
		} else if ($(".entry.current + .entry").length > 0 && ($(".entry.current + .entry").offset().top - $(window).scrollTop() < 150) && $(window).scrollTop() > lastScrollTop) {
			$(".entry.current + .entry").set_as_current_entry(false);
		} else if ($(".entry.current").prev(".entry").length > 0 && ($(window).scrollTop() - $(".entry.current").prev(".entry").find(".read-state").offset().top < -50) && $(window).scrollTop() < lastScrollTop) {
			$(".entry.current").prev(".entry").set_as_current_entry(false);
		};
		lastScrollTop = $(window).scrollTop();
	});
});

var lastScrollTop = 0;

$.fn.set_as_current_entry = function(should_snap) {
	$(".entry").removeClass("current");
	$(".entry:not(.unread)").addClass("read");

	this.addClass("current").removeClass("read")
	if (should_snap)
		this.snap_to_top();

	if (this.freshly_unread()) {
		this.removeClass("unread");
		if (!this.hasClass("dirty")) {
			var that = this;
			$.post("/reader/mark_as_read", {post_id: this.attr("post_id")}, function(ret) {
				if (that.hasClass("shared")) {
					shared_notch_unread_for_feed_id(ret.feed_id, -1);
				} else {
					notch_unread_for_feed_id(ret.feed_id, -1);
				}
				that.addClass("dirty");
			});
		};
	};
};

$.fn.freshly_unread = function() {
	return !this.find("span.read-state").hasClass("read-state-kept-unread") && this.hasClass("unread");
}

$.fn.toggle = function(span_selector, precondition, f) {
	var $span = this.find(span_selector);
	$span.hasClass(precondition) ? f(this, true) : f(this, false);
};

$.fn.share_with_note = function() {
	var note_content = this.find("textarea[name=note_content]").val();
	var post_id = this.attr("post_id");
	var that = this;
	$.post("/reader/share_with_note", {post_id: post_id, note_content: note_content}, function(ret) {
		that.find(".card-share-with-note").hide();
	});
};

var mark_as_read = function(selector, to_be_marked_as_read) {
	var $span = $(selector).find("span.read-state");
	if (to_be_marked_as_read) {
		$(selector).removeClass("unread").addClass("read");
		$span.removeClass("read-state-kept-unread").addClass("read-state-not-kept-unread");
	} else {
		$(selector).removeClass("read").addClass("unread");
		$span.removeClass("read-state-not-kept-unread").addClass("read-state-kept-unread");
	};
	$.post("/reader/mark_as_" + (to_be_marked_as_read ? "read" : "unread"), {post_id: $(selector).attr("post_id")}, function(ret) {
		if ($(selector).hasClass("shared")) {
			shared_notch_unread_for_feed_id(ret.feed_id, to_be_marked_as_read ? -1 : +1);
		} else {
			notch_unread_for_feed_id(ret.feed_id, to_be_marked_as_read ? -1 : +1);
		}
	});
};

var set_shared_status = function(selector, to_be_shared) {
	var $span = $(selector).find("span.item-star");
	if (to_be_shared) {
		$span.removeClass("star-inactive").addClass("star-active");
	} else {
		$span.removeClass("star-active").addClass("star-inactive");
	}
	$.post("/reader/post_" + (to_be_shared ? "share" : "unshare"), {post_id: $(selector).attr("post_id")});
};

var set_shared_with_note_status = function(selector, to_be_shared_with_note) {
	var $span = $(selector).find("span.share-with-note");
	if (to_be_shared_with_note) {
		$span.removeClass("share-with-note-inactive").addClass("share-with-note-active");
		$(selector).find(".card-share-with-note").show();
		$(selector).find(".card-share-with-note").find("textarea").focus();
	} else {
		$span.removeClass("share-with-note-active").addClass("share-with-note-inactive");
		$(selector).find(".card-share-with-note").hide();
		$.post("/reader/post_unshare", {post_id: $(selector).attr("post_id")});
	};
};