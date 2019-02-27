require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/app/admin/'
  add_filter '/app/channels/'
  add_filter '/app/jobs/'
  add_filter '/app/mailers/'
  add_filter '/bin/'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require 'webmock/minitest'
WebMock.disable_net_connect!

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end
