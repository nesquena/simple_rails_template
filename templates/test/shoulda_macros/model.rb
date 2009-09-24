ActiveRecord::Base.connection.class.class_eval do
  IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /SHOW FIELDS/]

  def execute_with_query_record(sql, name = nil, &block)
    $queries_executed ||= []
    $queries_executed << sql #unless IGNORED_SQL.any? { |r| sql =~ r }
    execute_without_query_record(sql, name, &block)
  end

  alias_method_chain :execute, :query_record
end

class ActiveRecord::TestCase
  class << self


#http://robots.thoughtbot.com/post/159807028/testing-paperclip-with-shoulda
    def should_have_attached_file(attachment)
      klass = self.name.gsub(/Test$/, '').constantize

      context "To support a paperclip attachment named #{attachment}, #{klass}" do
        should_have_db_column("#{attachment}_file_name",    :type => :string)
        should_have_db_column("#{attachment}_content_type", :type => :string)
        should_have_db_column("#{attachment}_file_size",    :type => :integer)
      end

      should "have a paperclip attachment named ##{attachment}" do
        assert klass.new.respond_to?(attachment.to_sym),
          "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
        assert_equal Paperclip::Attachment, klass.new.send(attachment.to_sym).class
      end
    end


    # ex. should_scope_include :include_users, :user
    def should_scope_include(named_scope, include_hash)
      should "scope include for #{named_scope} on #{self.described_type}" do
        assert subject.class.respond_to?(named_scope)
        expected_fragments = include_hash.inspect.scan(/\:(\w+)/).flatten.collect { |s| s.to_sym }
        class_names = {subject.class => subject.class.table_name}
        expected_fragments.each do |assoc|
          assoc_reflect = class_names.keys.collect { |klass| klass.reflect_on_association(assoc) }.compact.first
          class_names[assoc_reflect.class_name.constantize] = assoc_reflect.table_name unless assoc_reflect.nil?
        end
        factory_names = class_names.keys.collect { |klass| klass.to_s.underscore }
        factory_names.each{|klass| Factory(klass)}
        expected_sql = class_names.values.collect{|table_name| /`#{table_name}`/i}
        assert_sql(*expected_sql) do
          subject.class.all(:include => include_hash)
        end
      end
    end

    # ex. should_scope_order :by_recent, "form_entry_comments.created_at desc"
    def should_scope_order(named_scope, order_by)
      should "scope order for #{named_scope} on #{self.described_type}" do
        assert subject.class.respond_to?(named_scope)
        assert_sql(/order by #{order_by}/i) do
          subject.class.all(:order => order_by)
        end
      end
    end

    # ex. should_scope_conditions :only_templates, :is_template => :true
    def should_scope_conditions(named_scope, conditions)
      should "scope conditions for #{named_scope} on #{self.described_type}" do
        assert subject.class.respond_to?(named_scope)
        if conditions.is_a?(Hash)
          expected_sql = conditions.collect do |attribute, value|
            value = value ? 1 : 0 if value.to_s =~ /(true|false)/
            /`#{subject.class.table_name}`.`#{attribute}` = #{value}/i
          end
        else
          expected_sql = conditions
        end
        assert_sql(*expected_sql) do
          subject.class.all(:conditions => conditions)
        end
      end
    end

  end
end
