class ReaderController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @subscriptions = current_user.subscriptions
    @entries = current_user.feeds.find_by_id(params[:feed_id] || 13).posts
  end
end
