ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'functional_helper'

class ActiveSupport::TestCase
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all  

  # Add more helper methods to be used by all tests here...
  def assert_false(stmt, message=nil)
    assert !stmt, message
  end

  def assert_invalid(record, message=nil)
    assert_false record.valid?, message
  end

  def assert_size(expected_size, collection)
    assert_equal expected_size, collection.size, "collection with size #{collection.size} should be #{expected_size}"
  end

  # assert_includes Patient1, @facility.patients
  # assert_includes [Patient1, Patient2], @facility.patients
  def assert_includes(expected_items, actual_collection)
    expected_items = [expected_items].flatten
    expected_items.each do |item|
      assert actual_collection.include?(item), "collection should include #{item.inspect}"
    end
  end

  # assert_not_includes Patient1, @facility.patients
  # assert_not_includes [Patient1, Patient2], @facility.patients
  def assert_not_includes(expected_items, actual_collection)
    expected_items = [expected_items].flatten
    expected_items.each do |item|
      assert_false actual_collection.include?(item), "collection should not include #{item.inspect}"
    end
  end

  # assert_valid_attributes @user, [:first_name, :last_name], "bob", "joe"
  def assert_valid_attributes(object, attributes, *values)
    attributes = [attributes].flatten
    values.each do |value|
      attributes.each do |attribute|
        object.send("#{attribute}=", value)
        assert object.valid?, "'#{value}' should be a valid #{attribute} for #{object.class}"
      end
    end
  end

  # assert_valid_attributes @user, :first_name, " ", "12"
  def assert_invalid_attributes(object, attributes, *values)
    attributes = [attributes].flatten
    values.each do |value|
      attributes.each do |attribute|
        object.send("#{attribute}=", value)
        assert_invalid object, "'#{value}' should not be a valid #{attribute} for #{object.class}"
      end
    end
  end
  
  # document.fire('form:preview', {"hey": "hi", "html": "WHAT TO TEST", "hi": "hello" }
  # assert_select_event_html :html do
  #   assert_select "ol"
  # end
  def assert_select_event_html(key, &block)
    old_body, old_content = @response.body, @response.content_type
    @response.content_type = "text/html"
    @response.body = event_memo_for(key)
    instance_eval(&block)
    @response.body, @response.content_type = old_body, old_content
  end
  
  # works for document.fire where a json hash is passed as the memo
  # returns the value for a memo parameter
  # grab_json_element :errors
  def event_memo_for(key)
    ::JSON.parse(@response.body.gsub(/.*(\{.*\}).*/, '\1'))[key.to_s]
  end

end
