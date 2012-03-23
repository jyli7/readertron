$(document).ready(function() {	
	$("#alert").fadeOut(3000);
	
	$("#start-readertron").click(function() {
		window.location = "/";
	});
	
	$("#subscriptions li").click(function() {
		SETTINGS.feed_id = $(this).split_id();
		SETTINGS.page = 0;
		update_items_filter_control_counts();
		fetch_entries();
		$("#subscriptions li, #subscriptions h3").removeClass("selected");
		$(this).addClass("selected");
		return false;
	});
	
	$(".meta-page input[type=text], .meta-page input[type=password], .meta-page input[type=email]").focus(function() {
		placeholderStack.push($(this).attr("placeholder"));
		$(this).attr("placeholder", "");
	});
	
	$(".meta-page input[type=text], .meta-page input[type=password], .meta-page input[type=email]").focusout(function() {
		$(this).attr("placeholder", placeholderStack.pop());
	})
	
	$("#subscriptions h3").click(function() {
		if ($(this).attr("id") == "my-shared-items") {
			window.location = "/reader/mine";
			return false;
		};
		SETTINGS.feed_id = $(this).attr("feed_id");
		update_items_filter_control_counts();
		$("#subscriptions li").removeClass("selected");
		$("#subscriptions h3").removeClass("selected");
		$(this).addClass("selected");
		SETTINGS.page = 0;
		fetch_entries();
		return false;
	});
	
	$("#all-items-link").closest("h3").addClass("selected");

	$("#subscriptions").slimScroll({
		height: $(window).height() + "px",
		wheelStep: 5,
		allowPageScroll: false
	});

	$(".item-body a").live("click", function() {
		window.open($(this).attr("href"), '_blank');
		return false;
	});
	
	$(".view-all-items").live("click", function() {
		SETTINGS.page = 0;
		SETTINGS.items_filter = "all";
		$("#unread-or-all .menu-button-caption").text("All items");
		fetch_entries();
	});
	
	if ($("#entries").length > 0) {
		$(document).scroll(function() {
			if (scrollFetchFlag && ($("#entries").height() - $(window).scrollTop() < 2700)) {
				SETTINGS.page = SETTINGS.page + 1;
				scrollFetchFlag = false;
				append_entries();
			};
		});
		update_items_filter_control_counts();	
	};
	
	$("#logo").click(function() {
		window.location = "/";
	});
});

var placeholderStack = [];

var scrollFetchFlag = true;

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
	var new_n = this.get_int() + n;
	this.replace_int(new_n);
	(new_n == 0) ? this.hide().parent().removeClass("unread") : this.show().parent().addClass("unread");
	update_items_filter_control_counts();
};

$.fn.zero = function() {
	this.replace_int(0);
	this.hide().parent().removeClass("unread");
	update_items_filter_control_counts();
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
		$("#entry-" + next_post_index).set_as_current_entry(true);
	}
};

var fetch_entries = function() {
	$("#entries").empty();
	$("#loading-area-container").show();
	$.get("/reader/entries", SETTINGS, function(ret) {
		scrollFetchFlag = true;
		$("#entries").html(ret);
		$("#loading-area-container").hide();
		$.scrollTo($("#entries"), {offset: -50});
	});
};

var append_entries = function() {
	$("#entries").append($("#entries-loader").clone().show());
	$.get("/reader/entries", SETTINGS, function(ret) {
		if (ret.indexOf("no-entries-msg") != -1) {
			$("#entries #entries-loader").remove();
			$("#entries").append($("#end-of-the-line").clone().show());
			scrollFetchFlag = false;
		} else {
			$("#entries").append(ret);
			$("#entries #entries-loader").remove();
			scrollFetchFlag = true;			
		}
	});
};

var update_items_filter_control_counts = function() {
	var selector = "";
	if (SETTINGS.feed_id == "shared") {
		selector = "#shared-unread-count";
	} else if (SETTINGS.feed_id == "" || typeof(SETTINGS.feed_id) === "undefined") {
		selector = "#total-unread-count";
	} else {
		selector = "#feed-" + SETTINGS.feed_id + "-unread-count";
	};
	$(".items-filter-control-count").replace_int($(selector).get_int());
	$("#unread-or-all .menu-button-dropdown").css("left", ($("#unread-or-all .menu-button-caption").width() + 5) + "px")
};

var broadcast = function(msg) {
	$("#broadcast-message").text(msg).parent().show().fadeOut(3000);
};