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
});

var reset_unread_or_all_width = function() {
	$("#unread-or-all .menu-button-dropdown").css("left", ($(".menu-button-caption").width() + 5) + "px");
}