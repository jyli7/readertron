class FeedsController < ApplicationController
  def import
  end
  
  def import_upload
    current_user.bulk_subscribe(params[:opml].read)
    redirect_to action: :import
  end
end
