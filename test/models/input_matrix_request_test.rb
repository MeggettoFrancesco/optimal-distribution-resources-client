require 'test_helper'
require 'sidekiq/testing'
require 'models/_shared_models_test'

class InputMatrixRequestTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    request = build(:request, request_type: :input_matrix_request)
    @input_matrix_request = request.input_matrix_request
  end

  test 'valid input_matrix_request' do
    assert @input_matrix_request.valid?
  end

  test 'should be invalid without is_directed_graph' do
    invalid_without(@input_matrix_request, :is_directed_graph)
  end

  test 'should have a valid request' do
    assert @input_matrix_request.request.valid?
  end

  test 'create_api_request should create a OdrCreateApiRequestWorker job' do
    create_api_request_creates_job(@input_matrix_request)
  end

  test 'coordinates should return request.coordinates' do
    check_coordinates(@input_matrix_request)
  end
end
