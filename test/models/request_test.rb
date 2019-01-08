require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  setup do
    @request = build(:request)
  end

  test 'valid request' do
    assert @request.valid?
  end

  test 'should be invalid without request_type' do
    @request.request_type = nil
    assert @request.invalid?
  end

  test 'request_type should be in request_type.values' do
    assert Request.request_type.values.include?(@request.request_type)
  end

  test 'should be invalid without algorithm_type' do
    @request.algorithm_type = nil
    assert @request.invalid?
  end

  test 'algorithm_type should be in algorithm_type.values' do
    assert Request.algorithm_type.values.include?(@request.algorithm_type)
  end
end
