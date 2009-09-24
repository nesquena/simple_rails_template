#defining our own date format
my_formats = { :clean => '%a %m/%d/%y %I:%M %p', 
  :clean_long => '%A %B %d, %Y at %I:%M %p',
  :select => '%a %b %d, %y %I:%M %p',
  :clean_time => '%H:%M:%S',
  :short_time => lambda { |time| "#{time.strftime("%I").to_i}:#{time.strftime('%M %p')}"  },
  :clean_date => '%m/%d/%Y',
  :full_date => '%B %d, %Y',
  :full => lambda { |time| "#{time.strftime('%B %d, %Y')} at #{time.strftime('%I').to_i}:#{time.strftime('%M %p')}"  }
}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats) 
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(my_formats)