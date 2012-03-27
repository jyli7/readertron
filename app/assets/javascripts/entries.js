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
	
	$(".edit-note-link").live("click", function() {
		$(this).closest(".entry-note").find("form").show();
		$(this).closest(".entry-note").find(".note-content").hide();
		$(this).closest(".note-controls").hide();
	});
	
	$(".cancel-note-edit").live("click", function() {
		$(this).closest(".entry-note").find("form").hide();
		$(this).closest(".entry-note").find(".note-content").show();
		$(this).closest(".entry-note").find(".note-controls").show();
	});
	
	$(".entry-note input[type=submit]").live("click", function() {
		var that = this;
		$.post("/reader/edit_note", {
			post_id: $(this).closest(".entry").attr("post_id"), 
			content: $(this).closest(".entry-note").find("textarea").val()
		}, function(ret) {
			$(that).closest(".entry-note").replaceWith(ret);
		});
		return false;
	});
	
	$(".delete-note-link").live("click", function() {
		var okay = confirm("Are you sure?");
		if (okay) {
			var that = this;
			$.post("/reader/delete_note", {post_id: $(this).closest(".entry").attr("post_id")}, function(ret) {
				$(that).closest(".entry-note").remove();
			})
		}
	});
	
	if ($("#entries").length > 0) {
		$(document).scroll(function() {
			if ($(".entry.current").length == 0 && $(window).scrollTop() > lastScrollTop) {
				$(".entry:first").set_as_current_entry(false);
			} else if ($(".entry.current + .entry").length > 0 && ($(".entry.current + .entry").offset().top - $(window).scrollTop() < 100) && $(window).scrollTop() > lastScrollTop) {
				$(".entry.current + .entry").set_as_current_entry(false);
			} else if ($(".entry.current").prev(".entry").length > 0 && ($(window).scrollTop() - ($(".entry.current").prev(".entry").find(".read-state").offset() || $(".entry.current").prev(".entry").find(".add-comment-link").offset()).top < -50) && $(window).scrollTop() < lastScrollTop) {
				$(".entry.current").prev(".entry").set_as_current_entry(false);
			};
			lastScrollTop = $(window).scrollTop();
		});		
	}
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
			that.notch_unreads(-1);
			$.post("/reader/mark_as_read", {post_id: this.attr("post_id")}, function(ret) {
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
		broadcast("Your post and note have been shared successfully");
		that.find(".card-share-with-note").hide();
	});
};

$.fn.notch_unreads = function(n) {
	$("title").notch(n);
	var selectors = this.attr("unread_selectors").split(" ");
	for (var i in selectors) {
		$("#" + selectors[i]).notch(n);
	};
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
	$(selector).notch_unreads(to_be_marked_as_read ? -1 : +1);
	$.post("/reader/mark_as_" + (to_be_marked_as_read ? "read" : "unread"), {post_id: $(selector).attr("post_id")});
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