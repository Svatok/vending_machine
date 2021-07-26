require 'simplecov'
require 'ffaker'
require './config/initialization'

SimpleCov.profiles.define 'ruby' do
  add_filter '/spec/'

  add_group 'Db', '/db/'
  add_group 'Models', '/models/'
  add_group 'Lib', '/lib/'
end

SimpleCov.start 'ruby'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec::Matchers.define_negated_matcher :not_change, :change
