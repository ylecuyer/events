ruby '2.4.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'jbuilder'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'bullet'
end

gem 'simplecov', :require => false, :group => :test
gem 'codeclimate-test-reporter', :require => false, :group => :test
gem 'mocha', require: false, group: :test
gem 'capybara', require: false, group: :test
gem 'timecop', require: false, group: :test

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


gem 'simple_form'
gem 'figaro'
gem 'mailgun-ruby'
gem 'rqrcode'
gem 'paperclip'
gem 'wicked_pdf'
gem 'awesome_print'
gem 'sidekiq'
gem 'faraday'
gem 'devise'
gem 'pundit'
gem 'kaminari'
gem 'rolify'
gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'roo'
gem 'roo-xls'
gem 'mustache'
gem 'json-formatter-rails'

gem 'jquery-datatables-rails'
gem 'ajax-datatables-rails'
