template_path = File.expand_path(File.dirname(template), File.join(root,'..'))
app_name = @root.split('/').last
require  template_path + '/template_helper'

#Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"

# Copy database.yml
run 'mv config/database.yml config/database.yml.example'

# Create .gitignore file
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;"
file '.gitignore', <<-FILE
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
public/stylesheets/cache
public/stylesheets/cache/**/*
public/stylesheets/*.css
public/stylesheets/**/*.css
public/javascripts/cache
public/javascripts/cache/**/*
.svn*
FILE

# Freeze Rails into vendor/rails
# freeze! freezes rails edge
rake("rails:freeze:gems")

# Set up git repository
git :init
git :add => '.'
git :commit => "-a -m 'Initial rails commit'"

run 'cp config/database.yml.example config/database.yml'

# Gems
gem 'aws-s3', :lib => 'aws/s3'
gem 'haml'; run "haml --rails ."
gem 'ruby-openid', :lib => 'openid'
gem 'json'
gem 'mysql'
gem 'faker'
cutter_gem 'factory_girl'
cutter_gem 'paperclip'
cutter_gem 'will_paginate'
cutter_gem 'formtastic'
cutter_gem 'inherited_resources'
cutter_gem 'bullet'
cutter_gem 'block_helpers'
gh_gem 'internuity-quick_scopes'
gh_gem 'matthuhiggins-foreigner'

# Plugins
plugin 'hoptoad_notifier', :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
plugin 'ssl_requirement', :git => 'git://github.com/rails/ssl_requirement.git'
plugin 'asset_auto_include', :git => 'git://github.com/gabrielg/asset_auto_include.git'
plugin 'bundle-fu', :git => 'git://github.com/timcharper/bundle-fu.git'
plugin 'rack-bug', :git => 'git://github.com/brynary/rack-bug.git'
plugin 'rails_indexes', :git => 'git://github.com/eladmeidar/rails_indexes.git'
plugin 'smart_passenger_engine_reload', :git => 'git://github.com/2collegebums/smart_passenger_engine_reload.git'
run 'cp -R vendor/plugins/smart_passenger_engine_reload/lib/ lib/reload_server'

# production
gem 'slim_scrooge', :env => 'production'

# testing libraries
gh_gem 'thoughtbot-shoulda', :env => 'test'
gem 'mocha', :env => 'test'
gem 'fakefs', :env => 'test' # TODO from gemcutter ?
gh_gem 'mynyml-phocus', :env => 'test'
gh_gem 'timocratic-test_benchmark', :env => 'test'
plugin 'shmacros', :git => 'git://github.com/maxim/shmacros.git'

# Authlogic
gem 'authlogic'
generate(:session, "user_session")
generate(:controller, "user_sessions")
generate(:controller, 'users')
route('map.resource :user_session')
route('map.root :controller => "user_sessions", :action => "new"')
route('map.resource :account, :controller => "users"')
route('map.resources :users')
generate("formtastic_stylesheets")

#install missing gems
rake("gems:install", :sudo => true)

# Capify
capify!

#TODO copy the files over
copy_files_from_template(template_path)

if yes?("Would you like to setup MySQL?")
  socket = %w{/tmp/mysql.sock /var/run/mysql.sock /opt/local/var/run/mysql5/mysqld.sock}.detect do |f|
    File.exists?(f)
  end
  username = ask("MySQL Username: ")
  password = ask("MySQL Password: ")
  database_contents = File.read(template_path+"/database.mysql.yml")
  database_contents = database_contents.gsub(/USERNAME/, username).gsub(/PASSWORD/, password)
  database_contents = database_contents.gsub(/SOCKET/, socket).gsub(/APPNAME/, app_name)
  file('config/database.yml', database_contents)
  run 'rm db/*.sqlite3'
end

if yes?("Do you want to run db:migrate? (No need to adjust the users columns?)")
  rake "db:create:all"
  rake "db:migrate"
  rake "db:seed"
  rake "db:test:prepare"
  sleep(2)
  in_root { run "annotate" }
end

# Set up git repository
git :add => '.'
git :commit => "-a -m 'Initial source commit'"

# Success!
puts "SUCCESS!"
