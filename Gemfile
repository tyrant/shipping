source 'https://rubygems.org'

ruby '2.5.0'

gem 'will_paginate'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'capistrano', '~> 3.4.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv'
gem 'capistrano-rbenv-install', '~> 1.2.0'
gem 'capistrano-passenger'
#gem 'capistrano-faster-assets'

# bundle exec rails c production has stopped working! Ugh. Let's try this.
gem 'capistrano-rails-console'

# These are needed for the Production server! It's a Javascript runtime environment.
gem 'execjs'
gem 'therubyracer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Upgrading Rails has abstracted out respond_to.
gem 'responders', '~> 2.0'

gem 'backup'
gem 'backup-task'

gem 'awesome_print'

group :development, :test do

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
end

group :production do
  # stackoverflow.com/questions/22932282
  gem 'mysql2'

end

gem 'mimemagic', '~> 0.3.7' # CMS 1.12 requires 0.3.2 - https://rubygems.org/gems/mimemagic/versions says it's yanked!
gem 'comfortable_mexican_sofa', '~> 1.12.0'
