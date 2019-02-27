source 'https://rubygems.org'

gem 'activeadmin'
gem 'carrierwave', '~> 1.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'enumerize'
gem 'faraday', '~> 0.9.2'
gem 'jbuilder', '~> 2.5'
gem 'leaflet-rails'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop', '~> 0.62.0'
  gem 'selenium-webdriver'
  gem 'simplecov'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'flamegraph'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', '~> 0.10'
  gem 'stackprof'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
