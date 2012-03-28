class AdminController < ApplicationController
  before_filter :ensure_its_jimbo
  
  def dailies
    @dailies = Report.where(report_type: "Daily site report").order("created_at DESC").limit(10)
  end
  
  def fetches
    @fetches = Report.where(report_type: "Feed.refresh").order("created_at DESC").limit(30)
  end
  
  def ensure_its_jimbo
    unless current_user == User.find_by_email("jsomers@gmail.com")
      flash[:alert] = "You're not authorized to access that page"
      redirect_to "/"
    end
  end
end
