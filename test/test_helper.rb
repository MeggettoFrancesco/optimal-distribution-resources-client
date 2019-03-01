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

  # Open Street Maps
  def stub_osm_api_request(request)
    base_url = 'https://api.openstreetmap.org/api/0.6//map?bbox='
    min_lon = request.min_longitude
    min_lat = request.min_latitude
    max_lon = request.max_longitude
    max_lat = request.max_latitude
    url = "#{base_url}#{min_lon},#{min_lat},#{max_lon},#{max_lat}"
    stub_request(:get, url).to_return(status: 200, body: '')
  end

  # Odr API - Create Request
  def stub_odr_api_request(my_request)
    body = { status: 'ok', code: 200, request_uuid: SecureRandom.uuid }.to_json
    params = odr_api_request_parameters(my_request)
    stub_request(:post, 'http://172.18.0.1:3001/api/v1/requests')
      .with(body: { request: params })
      .to_return(status: 200, body: body)
  end

  # Odr API - Fetch Solution
  def stub_odr_api_solution_request(my_request)
    body = { status: 'ok', code: 200, result: [1, 2, 3, 4, 6, 7] }.to_json
    url = "http://172.18.0.1:3001/api/v1/requests/#{my_request.odr_api_uuid}"
    stub_request(:get, url)
      .to_return(status: 200, body: body)
  end

  # TagInfo popular tags
  def stub_popular_tags_api_request
    path = Rails.root.join('test', 'factories', 'files', 'popular_tags.json')
    stub_request(:get, 'https://taginfo.openstreetmap.org/api/4/tags/popular')
      .to_return(status: 200, body: path.read)
  end

  private

  def odr_api_request_parameters(my_request)
    {
      algorithm_parameters: {
        cycles: my_request.odr_api_cycles,
        input_matrix: my_request.odr_api_matrix,
        number_resources: my_request.odr_api_number_resources,
        path_length: my_request.odr_api_path_length
      },
      request_type: my_request.algorithm_type
    }
  end
end
