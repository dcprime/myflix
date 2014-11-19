source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bcrypt-ruby', '3.1.2' 
gem 'bootstrap_form'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'redis'
gem 'sidekiq'
gem 'unicorn'
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
gem 'paratrooper'
gem 'carrierwave'
gem 'fog'
gem "mini_magick"
gem 'stripe'

group :development do
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'shoulda'
  gem 'capybara'
  gem 'capybara-email', github: 'dockyard/capybara-email'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

