require "authlogic/test_case"
class ActionController::TestCase

  def post_with_user(action, params, user=nil)
    request_with_user(action, params, user) do |action, params|
      post action, params
    end
  end
  
  def delete_with_user(action, params, user=nil)
    request_with_user(action, params, user) do |action, params|
      delete action, params
    end
  end
  
  def put_with_user(action, params, user=nil)
    request_with_user(action, params, user) do |action, params|
      put action, params
    end
  end

  def ajax_with_user(action, params, user=nil)
    request_with_user(action, params, user) do |action, params|
      xhr :post, action, params
    end
  end

  def get_with_user(action, params, user=nil)
    request_with_user(action, params, user) do |action, params|
      get action, params
    end
  end

  private

  def request_with_user(action, params, user, &block)
    user ||= Factory(:user, :password => "example")
    activate_authlogic
    UserSession.create(user)
    block.call(action, params)
  end
end
