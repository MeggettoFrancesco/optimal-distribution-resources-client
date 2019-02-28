require 'test_helper'
require 'sidekiq/testing'
require 'models/_shared_models_test'

class OpenStreetMapRequestTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    request = build(:request, request_type: :open_street_map_request)
    @osm_request = request.open_street_map_request
  end

  test 'valid open_street_map_request' do
    stub_osm_api_request(@osm_request)
    assert @osm_request.valid?
  end

  test 'should have a valid request' do
    stub_osm_api_request(@osm_request)
    assert @osm_request.request.valid?
  end

  test 'invalid without min_longitude' do
    @osm_request.min_longitude = nil
    stub_osm_api_request(@osm_request)
    invalid_and_error_present(@osm_request, :min_longitude)
  end

  test 'invalid without min_latitude' do
    @osm_request.min_latitude = nil
    stub_osm_api_request(@osm_request)
    invalid_and_error_present(@osm_request, :min_latitude)
  end

  test 'invalid without max_longitude' do
    @osm_request.max_longitude = nil
    stub_osm_api_request(@osm_request)
    invalid_and_error_present(@osm_request, :max_longitude)
  end

  test 'invalid without max_latitude' do
    @osm_request.max_latitude = nil
    stub_osm_api_request(@osm_request)
    invalid_and_error_present(@osm_request, :max_latitude)
  end

  test 'invalid with empty tags' do
    stub_osm_api_request(@osm_request)
    @osm_request.tag_infos = []
    invalid_and_error_present(@osm_request, :tag_infos)
  end

  test 'should have 1+ tag' do
    stub_osm_api_request(@osm_request)
    assert_operator @osm_request.tag_infos.size, :>=, 1
    assert @osm_request.valid?
  end

  test 'display_name should not be empty' do
    assert_not_empty @osm_request.display_name
  end

  # set_matrix

  test 'create_api_request should create a OdrCreateApiRequestWorker job' do
    Sidekiq::Worker.clear_all
    @osm_request.create_api_request
    assert_equal 1, OdrCreateApiRequestWorker.jobs.size
  end

  # coordinates
end
