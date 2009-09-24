module ARExtensions
  
  #model.eager_loaded?(:association)
  def eager_loaded?(association)
    self.instance_variable_get("@#{association}")
  end
  
end

ActiveRecord::Base.send(:include, ARExtensions)