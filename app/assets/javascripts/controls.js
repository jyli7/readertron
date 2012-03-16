$(document).ready(function() {
	$("#viewer-refresh").mouseover(function() {
		$(this).removeClass("jfk-button-standard").addClass("jfk-button-hover");
	});

	$("#viewer-refresh").mouseout(function() {
		$(this).removeClass("jfk-button-hover").addClass("jfk-button-standard");
	});

	$("#viewer-refresh").click(function() {
		fetch_entries();
		return false;
	});
	
	reset_unread_or_all_width();
	
	$("#unread-or-all").mouseover(function() {
		$(this).removeClass("jfk-button-standard").addClass("jfk-button-hover");
	});

	$("#unread-or-all").mouseout(function() {
		$(this).removeClass("jfk-button-hover").addClass("jfk-button-standard");
	});
	
	$("#unread-or-all").click(function() {
		$("#unread-or-all-menu").show();
		$(document).one("click", function() {
			$("#unread-or-all-menu").hide();
		});
		event.stopPropagation();
	});
	
	$('#feed-all-items-filter').click(function() {
		POST_FILTERS.items_filter = "all";
		$(".menu-button-caption").text("All items");
		reset_unread_or_all_width();
		fetch_entries();
	});
	
	$("#feed-unread-items-filter").click(function() {
		POST_FILTERS.items_filter = "unread";
		$(".menu-button-caption").html("<span id='new-items-count-visible'>" + $("#new-items-count-hidden").text() + "</span> new items")
		reset_unread_or_all_width();
		fetch_entries();
	});
	
	$("#revchron").mouseover(function() {
		$(this).removeClass("jfk-button-unchecked").addClass("jfk-button-hover");
	});

	$("#revchron").mouseout(function() {
		$(this).addClass("jfk-button-standard");
	});
	
	$("#revchron").click(function() {
		$("#chron").removeClass("jfk-button-checked").addClass("jfk-button-unchecked");
		$(this).removeClass("jfk-button-unchecked").addClass("jfk-button-checked");
		POST_FILTERS.date_sort = "revchron";
		fetch_entries();
	});
	
	$("#chron").mouseover(function() {
		$(this).removeClass("jfk-button-unchecked").addClass("jfk-button-hover");
	});

	$("#chron").mouseout(function() {
		$(this).addClass("jfk-button-standard");
	});
	
	$("#chron").click(function() {
		$("#revchron").removeClass("jfk-button-checked").addClass("jfk-button-unchecked");
		$(this).removeClass("jfk-button-unchecked").addClass("jfk-button-checked");
		POST_FILTERS.date_sort = "chron";
		fetch_entries();
	});
	
	$("#mark-all-as-read").mouseover(function() {
		$(this).removeClass("jfk-button-standard").addClass("jfk-button-hover");
	});

	$("#mark-all-as-read").mouseout(function() {
		$(this).removeClass("jfk-button-hover").addClass("jfk-button-standard");
	});

	$("#mark-all-as-read").click(function() {
		if (SHARED_UNREAD_COUNTS[POST_FILTERS.feed_id] != undefined) {
			SHARED_UNREAD_COUNTS[POST_FILTERS.feed_id] = 0
		} else if (UNREAD_COUNTS[POST_FILTERS.feed_id] != undefined) {
			UNREAD_COUNTS[POST_FILTERS.feed_id] = 0
		} else if (POST_FILTERS.feed_id == "shared") {
			for (k in SHARED_UNREAD_COUNTS) {
				SHARED_UNREAD_COUNTS[k] = 0;
			};
		} else if (POST_FILTERS.feed_id == "" || POST_FILTERS.feed_id == undefined) {
			for (k in UNREAD_COUNTS) {
				UNREAD_COUNTS[k] = 0;
			};
		};
		$.post("/reader/mark_all_as_read", {feed_id: POST_FILTERS.feed_id}, function(ret) {
			fetch_entries();
			broadcast("Marked all entries as read.")
		});
		return false;
	});
	
});

var reset_unread_or_all_width = function() {
	$("#unread-or-all .menu-button-dropdown").css("left", ($(".menu-button-caption").width() + 5) + "px");
}