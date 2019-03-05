require 'test_helper'
require 'sidekiq/testing'
require 'models/_shared_models_test'

class RequestTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    @request = build(:request, request_type: :input_matrix_request)
  end

  test 'valid request' do
    assert @request.valid?
  end

  test 'should be invalid without request_type' do
    invalid_without(@request, :request_type)
  end

  test 'request_type should be in request_type.values' do
    assert Request.request_type.values.include?(@request.request_type)
  end

  test 'should be invalid without algorithm_type' do
    invalid_without(@request, :algorithm_type)
  end

  test 'algorithm_type should be in algorithm_type.values' do
    assert Request.algorithm_type.values.include?(@request.algorithm_type)
  end

  test 'should be invalid without odr_api_matrix' do
    invalid_without(@request, :odr_api_matrix)
  end

  test 'should be invalid without odr_api_path_length' do
    invalid_without(@request, :odr_api_path_length)
  end

  test 'invalid with odr_api_path_length less or equal to zero' do
    valid_if_greater_than_one(@request, :odr_api_path_length)
  end

  test 'should be invalid without odr_api_number_resources' do
    invalid_without(@request, :odr_api_number_resources)
  end

  test 'invalid with odr_api_number_resources less or equal to zero' do
    valid_if_greater_than_one(@request, :odr_api_number_resources)
  end

  test 'should be invalid without odr_api_cycles' do
    invalid_without(@request, :odr_api_cycles)
  end

  test 'children other than current one should be nil' do
    current_type = @request.request_type
    (Request.request_type.values - [current_type]).each do |e|
      assert_nil @request.send(e)
    end

    assert_not_nil @request.send(current_type)
  end

  test 'after a build_nested_associations, it should have all
        request_types nested resources present' do
    @request.build_nested_associations
    Request.request_type.values.each do |request_type|
      assert @request.send(request_type).present?
    end
  end

  test 'coordinates should return coordinates of specific type' do
    perform_odr_api_calls(@request)

    sub_type_coordinates = @request.send(@request.request_type).coordinates
    assert_equal sub_type_coordinates, @request.coordinates
  end

  test 'input_matrix_request? should be true if that type' do
    input_request = build(:request, request_type: :input_matrix_request)
    assert input_request.input_matrix_request?
  end

  test 'open_street_map_request? should be true if that type' do
    osm_request = build(:request, request_type: :open_street_map_request)
    assert osm_request.open_street_map_request?
  end

  test 'delete_unwanted_nested_associations should delete all unwanted
        sub_types' do
    @request.build_nested_associations
    @request.delete_unwanted_nested_associations

    current_type = @request.request_type
    (Request.request_type.values - [current_type]).each do |request_type|
      assert @request.send(request_type).destroyed?
    end
  end

  test 'on save of new object, should create a OdrCreateApiRequestWorker job' do
    create_api_request_creates_job(@request)
  end
end
