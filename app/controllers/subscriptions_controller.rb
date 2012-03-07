class SubscriptionsController < ApplicationController
  def index
  end
  
  def upload
    current_user.bulk_subscribe(params[:opml].read)
    redirect_to action: :index
  end
end
