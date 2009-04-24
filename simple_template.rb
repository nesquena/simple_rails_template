raw_template_path = "http://github.com/nesquena/simple_rails_template/raw/master"
javascript_template_path = "#{raw_template_path}/javascripts"
javascript_animator_path = "http://github.com/nesquena/prototype_animator/raw/master/javascripts/prototype_animator.js"

# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"

# Download javascript files
run "curl -s -L #{javascript_template_path}/protoculous_all.js > public/javascripts/protoculous.js"
run "curl -s -L #{javascript_template_path}/lowpro.js > public/javascripts/lowpro.js"
run "curl -s -L #{javascript_template_path}/animator.js > public/javascripts/animator.js"
run "curl -s -L #{javascript_animator_path} > public/javascripts/prototype_animator.js"

# Set up git repository
git :init
git :add => '.'

# Copy database.yml
run 'cp config/database.yml config/database.yml.example'

# Gems
gem 'aws-s3', :lib => 'aws/s3'
gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
gem 'faker'
gem 'haml'; run "haml --rails ."
gem 'ruby-openid', :lib => 'openid'
gem 'json'
gem 'mysql'

# Authlogic
gem 'authlogic'
# MORE SETUP !!!!

# Plugins
plugin 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
plugin 'hoptoad_notifier', :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
plugin 'ssl_requirement', :git => 'git://github.com/rails/ssl_requirement.git'

# Hoptoad
initializer 'hoptoad.rb', <<-FILE
HoptoadNotifier.configure do |config|
  config.api_key = 'HOPTOAD-KEY'
end
FILE

# Freeze Rails into vendor/rails
freeze!

# Capify
capify!
file 'Capfile', <<-FILE
  load 'deploy' if respond_to?(:namespace) # cap2 differentiator
  Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
  load 'config/deploy'
FILE

# Create .gitignore file
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;"
file '.gitignore', <<-FILE
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
.svn*
FILE

# Set up git repository
git :add => '.'
git :commit => "-a -m 'Initial commit'"

# Success!
puts "SUCCESS!"