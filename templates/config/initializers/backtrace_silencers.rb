# Be sure to restart your server when you modify this file.

# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
# Rails.backtrace_cleaner.add_silencer { |line| line =~ /my_noisy_library/ }

# You can also remove all the silencers if you're trying do debug a problem that might steem from framework code.
# Rails.backtrace_cleaner.remove_silencers!
#


Rails.backtrace_cleaner.add_silencer { |line| line =~ /thoughtbot-shoulda/ }
Rails.backtrace_cleaner.add_silencer { |line| line =~ /lib\/(haml|sass)/ }

Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{/System/Library/Frameworks/Ruby.framework/Versions/1.8} }
Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{lib/phusion_passenger} }
Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{__DELEGATION__} }
Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{kernel_extension\.rb} }
Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{.*?/Library/Ruby/Gems/1.8/gems/haml.*} }