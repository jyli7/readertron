class ReaderController < ApplicationController
  before_filter :authenticate_user!, except: :create_post
  
  def index
    @regular_subscriptions = current_user.regular_subscriptions
    @shared_subscriptions = current_user.shared_subscriptions
    @entries = Post.for_options(current_user, "chron", "unread")
    @unread_counts = Subscription.unread_hash_for_user(current_user)
    @shared_unread_counts = Subscription.shared_unread_hash_for_user(current_user)
  end
  
  def entries
    @entries = Post.for_options(current_user, params[:date_sort], params[:items_filter], params[:feed_id])
    if feed = Feed.find_by_id(@feed_id = params[:feed_id])
      @feed_name = (feed.title || feed.feed_url) 
    end
    render layout: false
  end
  
  def mark_as_read
    post = Post.find(params[:post_id])
    Unread.find_by_user_id_and_post_id(current_user.id, post.id).try(:destroy)
    render json: {feed_id: post.feed.id}
  end
  
  def mark_as_unread
    post = Post.find(params[:post_id])
    unless (u = Unread.find_by_user_id_and_post_id(current_user.id, post.id))
      u = Unread.create(post_id: post.id, user_id: current_user.id)
    end
    render json: {feed_id: post.feed.id}
  end
  
  def post_share
    post = Post.find(params[:post_id])
    unless (share = current_user.feed.posts.find_by_original_post_id(params[:post_id]))
      current_user.feed.posts.create(post.attributes.merge(shared: true, original_post_id: post.id))
    end
    render text: "OK"
  end
  
  def post_unshare
    post = current_user.feed.posts.find_by_original_post_id(params[:post_id])
    post.try(:destroy)
    render text: "OK"
  end
  
  def share_with_note
   post = Post.find(params[:post_id])
    unless (share = current_user.feed.posts.find_by_original_post_id(params[:post_id]))
      current_user.feed.posts.create(post.attributes.merge(shared: true, original_post_id: post.id, note: params[:note_content]))
    end
    render text: "OK"
  end
  
  def create_comment
    post = Post.find(params[:post_id])
    comment = post.comments.create(content: params[:comment_content], user: current_user)
    render partial: "reader/comment", :locals => {comment: comment}
  end
  
  def delete_comment
    comment = Comment.find_by_id(params[:comment_id])
    if comment && comment.user == current_user
      comment.destroy
    end
    render text: "OK"
  end
  
  def edit_comment
    comment = Comment.find_by_id(params[:comment_id])
    if comment && comment.user == current_user
      comment.update_attributes({content: params[:comment_content]})
    end
    render partial: "reader/comment", :locals => {comment: comment}
  end
  
  def create_post
    p = User.find_by_share_token(params[:token]).feed.posts.create(
      content: params[:content],
      url: params[:url],
      note: params[:note],
      title: params[:title],
      published: Time.now,
      shared: true
    )
    p.update_attributes({original_post_id: p.id})
    render text: "OK"
  end
end
