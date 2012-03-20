class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subscriptions = current_user.subscriptions.joins("JOIN feeds ON subscriptions.feed_id = feeds.id").order("feeds.last_modified DESC")
  end
  
  def create
    current_user.subscribe(params[:feed_url])
    flash[:alert] = "Your subscription has been added successfully! (See below)"
    redirect_to action: :index
  end
  
  def upload
    current_user.bulk_subscribe(params[:opml].read)
    flash[:alert] = "Your subscriptions have been added successfully! (See below)"
    redirect_to action: :index
  end
  
  def destroy
    current_user.subscriptions.find(params[:id]).destroy
    redirect_to action: :index
  end
  
  def shared_feeds
    params["feeds"].each do |feed_id, checked|
      if checked == "1"
        unless current_user.subscriptions.find_by_feed_id(feed_id)
          current_user.subscriptions.create(feed: Feed.find(feed_id))
        end
      else
        current_user.subscriptions.find_by_feed_id(feed_id).try(:destroy)
      end
    end
    redirect_to action: :index
  end
  
  def instapaper
    current_user.update_attributes(instapaper_username: params[:username], instapaper_password: params[:password])
    redirect_to action: :index
  end
end