# frozen_string_literal: true

source 'https://rubygems.org'

ruby(File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip)

group :development, :test do
  gem 'ffaker', '~> 2.18'
  gem 'pry', '~> 0.13'
  gem 'rspec', '~>3.10'

  # Code quality
  gem 'bundle-audit', '~> 0.1', require: false
  gem 'fasterer', '~> 0.9', require: false
  gem 'rubocop', '~> 0.93', require: false
  gem 'rubocop-rspec', '~> 1.43', require: false
end

group :test do
  gem 'simplecov', '~> 0.21', require: false
end
