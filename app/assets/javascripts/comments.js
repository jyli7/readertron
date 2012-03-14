$(document).ready(function() {
	$(".comments .add-comment-link").live("click", function() {
		var $entry = $(this).closest(".entry");
		$entry.find(".comment-add-form form").show();
		$(this).hide();
		return false;
	});

	$(".comments .cancel-comment-add").live("click", function() {
		$(this).closest(".comment-add-form").find("form").hide();
		$(this).closest(".comments").find(".add-comment-link").show();
		return false;
	});

	$(".comments .comment-add-form input[type=submit]").click(function() {
		add_comment($(this).closest(".entry"));
		return false;
	});

	$(".comments .comment-delete-link").live("click", function() {
		var $comment = $(this).closest(".comment");
		$.post("/reader/delete_comment", {comment_id: $comment.attr("comment_id")}, function(ret) {
			$comment.closest(".comments").find(".comments-count").notch(-1);
			$comment.remove();
		});
		return false;
	});

	$(".comments .comment-actions .comment-edit-link").live("click", function() {
		var $comment = $(this).closest(".comment");
		$comment.find(".comment-actions").hide();
		$comment.find(".comment-content").hide();
		$comment.find(".comment-timestamp").hide();
		$comment.find(".comment-body form").show();
		return false;
	});

	$(".comments .after-actions .cancel-comment-edit").live("click", function() {
		var $comment = $(this).closest(".comment");
		$comment.find(".comment-actions").show();
		$comment.find(".comment-content").show();
		$comment.find(".comment-timestamp").show();
		$comment.find(".comment-body form").hide();
		return false;
	});

	$(".comments .comment form input[type=submit]").live("click", function() {
		var $comment = $(this).closest(".comment");
		$.post("/reader/edit_comment", {comment_id: $comment.attr("comment_id"), comment_content: $comment.find("form textarea[name=comment_content]").val()}, function(ret) {
			$comment.replaceWith(ret);
		});
		return false;
	});
});

var add_comment = function(entry) {
	var comment_content = $(entry).find(".comment-add-form textarea[name=comment_content]").val();
	var post_id = $(entry).attr("post_id");
	$.post("/reader/create_comment", {post_id: post_id, comment_content: comment_content}, function(ret) {
		$(entry).find(".comment-add-form form").hide();
		$(entry).find(".comments .add-comment-link").show();
		$(entry).find(".comments-count").notch(+1);
		$(entry).find(".comments-container").append(ret);
	});
};