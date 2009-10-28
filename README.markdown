Overview
========

Simple rails template which serves my needs for a new application.

Usage
------

Simply invoke the rails command in the terminal

    git clone git://github.com/nesquena/simple_rails_template.git
    rails my_app -d mysql -m simple_rails_template/simple_template.rb
    
Included
--------

The following is an attempt to compile a list of everything included in this template:

### Steps ###

 * Remove useless rails README
 * Remove public/index.html
 * Remove the rails image at public/images/rails.png
 * Remove the default javascript prototype files
 * Add a standard .gitignore file
 * Freeze the stable rails gems into vendor
 * Initialize the git repository and commit the initial code

### Gems ###

General:

 * authlogic (with pre-built views, models and controllers)
 * haml
 * json
 * mysql
 * paperclip
 * will_paginate
 * inherited_resources
 * quick_scopes
 * foreigner
 * bullet
 * block_helpers
 
Testing:

 * faker
 * factory_girl
 * mocha
 * fakefs
 * phocus
 * test_benchmark
 * shmacros 

### Plugins ###

 * hoptoad_notifier
 * ssl_requirement
 * `asset_auto_include`
 * bundle_fu
 * rack-bug