class ReaderController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @entries = current_user.feeds.last.posts
  end
end
