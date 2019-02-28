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

  def stub_osm_api_request(request)
    base_url = 'https://api.openstreetmap.org/api/0.6//map?bbox='
    min_lon = request.min_longitude
    min_lat = request.min_latitude
    max_lon = request.max_longitude
    max_lat = request.max_latitude
    url = "#{base_url}#{min_lon},#{min_lat},#{max_lon},#{max_lat}"
    stub_request(:get, url).to_return(status: 200, body: '', headers: {})
  end
end
