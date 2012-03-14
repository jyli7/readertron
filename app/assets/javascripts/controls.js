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
	
	$("#unread-or-all .menu-button-dropdown").css("left", ($(".menu-button-caption").width() + 5) + "px");
	
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
		SETTINGS.items_filter = "all";
		$(".menu-button-caption").text("All items")
		$("#unread-or-all .menu-button-dropdown").css("left", ($(".menu-button-caption").width() + 5) + "px");
		fetch_entries();
	});
	
	$("#feed-unread-items-filter").click(function() {
		SETTINGS.items_filter = "unread";
		$(".menu-button-caption").html("<span id='new-items-count-visible'>" + $("#new-items-count-hidden").text() + "</span> new items")
		$("#unread-or-all .menu-button-dropdown").css("left", ($(".menu-button-caption").width() + 5) + "px");
		fetch_entries();
	});
});