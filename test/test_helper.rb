require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'timecop'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

include Warden::Test::Helpers

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures Dir["#{fixture_path}/{**,*}/*.{yml}"].reject { |x| x.match 'vcr_cassettes' }.uniq.map! { |f| f[(fixture_path.to_s.size + 1)..-5] }

  # Add more helper methods to be used by all tests here...
end
