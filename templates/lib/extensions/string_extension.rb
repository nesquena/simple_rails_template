class String
  
  def embrace(char=[" (", ")"])
    char.is_a?(Array) ? "#{char.first}#{self}#{char.second}" : "#{char}#{self}#{char}"
  end
  
  alias_method :method_missing_old, :method_missing
  def method_missing(method_name, *arguments)
    if method_name.to_s.ends_with?("?")
      self == method_name.to_s[0..-2]
    else
      super
    end
  end
end