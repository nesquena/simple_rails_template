class UserSessionsController < InheritedResources::Base

  before_filter :require_logged_out, :only => [:new, :create]
  before_filter :require_logged_in, :only => :destroy
  
  respond_to :html
  actions :new, :create, :destroy

  create! do |success, failure|
    success.html { redirect_to account_url }
  end

  def destroy
    current_user_session.destroy
    redirect_to new_user_session_url
  end
end
