class ReaderController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @regular_subscriptions = current_user.regular_subscriptions
    @shared_subscriptions = current_user.shared_subscriptions
    if !current_user.feeds.empty?
      feed_id = params[:feed_id]
      if feed_id
        if (feed = Feed.find(feed_id)) && !feed.shared?
          @entries = current_user.feeds.find_by_id(feed_id).posts.unread_for_user(current_user).limit(10)
          @shares = []
        else
          @entries = []
          @shares = current_user.feeds.find_by_id(feed_id).posts.unread_for_user(current_user).limit(10)
        end
      else
        @entries = current_user.feeds.collect {|f| f.posts.unread_for_user(current_user)}.flatten.sample(10).sort {|a, b| b.published <=> a.published }
        @shares = []
      end
    else
      redirect_to controller: :subscriptions
    end
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
end
