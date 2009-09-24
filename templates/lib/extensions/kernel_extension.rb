module Kernel
  # TODO if its a model, show the class, attribute values and errors
  def raise_with_inspect(*args)
    raise_without_inspect(*args)
  rescue Exception => e
    obj = args.first
    if e.message =~ /exception class\/object expected/
      raise_without_inspect obj.inspect
    else
      raise_without_inspect(*args)
    end
  end
  alias_method_chain :raise, :inspect
  
  def log(arg, caption="Logged")
    Rails.logger.info "\n\n#{caption}:\n"
    Rails.logger.info arg.inspect
    Rails.logger.info("\n\n\n")
  end
end
