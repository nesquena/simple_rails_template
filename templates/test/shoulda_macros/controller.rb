class ActionController::TestCase
  class << self


    def should_render_form_for(record)
      should("render a form for #{record}") do
        assert_select "form" do
          assert_select "input[name*=#{record}]"
        end
      end
    end

    def should_have_form_with_action(&block)
      should("render a form with action") do
        action_url = instance_eval(&block)
        assert_select "form[action*=#{action_url}]"
      end
    end
    # should_render_flash_as(:login, "bob")
    def should_render_flash_as(key, message=nil)
      flash_message = (message.nil? ? Flash.message(key) : Flash.custom_message(key, message))
      should_set_the_flash_to(flash_message)
    end

    # should_require_login_on :index, :show
    def should_require_login_on(*actions)
      actions.each do |action|
        should "require login for #{action} action" do
          get action, {}, {}
          assert_redirected_to new_user_session_path
        end
      end
    end

    def should_contain_in_body(*matches)
      matches.each do |match|
        should "contain #{match.inspect} in response body" do
          assert_match match, @response.body
        end
      end
    end

    #should_have_errors_on(:first_name, :phone){ @user }
    def should_have_errors_on(*attributes, &block)
      should "have errors on #{attributes.to_sentence} for record" do
        record = instance_eval(&block)
        attributes.each do |attr|
          assert record.errors.on(attr), "#{attr} should be invalid for #{record.class}"
        end
      end
    end

    def should_fire_javascript_event(event_name, json_param=nil, &block)
      should("fire event #{event_name} in response") do
        assert_match /document\.fire\([\'\"]#{event_name.gsub(":", "\\:")}[\'\"]/, @response.body
      end
      should("contain for #{event_name} parameter #{json_param}") do
        assert_select_event_html(json_param, &block)
      end if json_param
    end

  end
end
