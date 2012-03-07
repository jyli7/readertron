class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subscriptions = current_user.subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").order("feeds.last_modified DESC")
  end
  
  def create
    current_user.subscribe(params[:feed_url])
    redirect_to action: :index
  end
  
  def upload
    current_user.bulk_subscribe(params[:opml].read)
    redirect_to action: :index
  end
  
  def destroy
    current_user.subscriptions.find(params[:id]).destroy
    redirect_to action: :index
  end
end