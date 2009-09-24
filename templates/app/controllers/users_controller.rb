class UsersController < InheritedResources::Base
  before_filter :require_logged_out, :only => [:new, :create]
  before_filter :require_logged_in, :only => [:show, :edit, :update]
  before_filter :setup_user, :only => [:show, :edit, :update]

  respond_to :html
  actions :new, :create, :edit, :update, :show

  create! do |success, failure|
    success.html { redirect_to account_url }
  end

  update! do |success, failure|
    success.html { redirect_to account_url }
  end

  protected

  def setup_user
    @user = current_user
  end
end
