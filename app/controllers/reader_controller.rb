class ReaderController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @subscriptions = current_user.subscriptions
    @entries = current_user.feeds.find_by_id(params[:feed_id] || 151).posts.unread_for_user(current_user).limit(10)
  end
  
  def mark_as_read
    post = Post.find(params[:post_id])
    Unread.find_by_user_id_and_post_id(current_user.id, post.id).try(:destroy)
    render json: {feed_id: post.feed.id, unread_count: post.feed.subscriptions.find_by_user_id(current_user.id).unread_count}.to_json
  end
  
  def mark_as_unread
    post = Post.find(params[:post_id])
    unless (u = Unread.find_by_user_id_and_post_id(current_user.id, post.id))
      u = Unread.create(post_id: post.id, user_id: current_user.id)
    end
    render json: {feed_id: post.feed.id, unread_count: post.feed.subscriptions.find_by_user_id(current_user.id).unread_count}.to_json
  end
end
