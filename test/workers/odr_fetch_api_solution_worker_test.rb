require 'test_helper'
require 'sidekiq/testing'
require 'workers/_stub_requests'

class OdrFetchApiSolutionWorkerTest < Minitest::Test
  include FactoryBot::Syntax::Methods
  include StubRequests

  def setup
    Sidekiq::Worker.clear_all
    @my_request = create(:request)
    stub_odr_api_request(@my_request)
    OdrCreateApiRequestWorker.drain
    @my_request.reload
  end

  def test_solution_is_updated_if_200
    stub_odr_api_solution_request(@my_request)
    OdrFetchApiSolutionWorker.drain

    assert_equal 0, OdrFetchApiSolutionWorker.jobs.size
    assert @my_request.reload.solution
  end

  def test_solution_is_still_nil_if_still_computing
    stub_still_computing_odr_api_solution_request(@my_request)

    OdrFetchApiSolutionWorker.drain
  rescue StandardError
    assert_equal 0, OdrCreateApiRequestWorker.jobs.size
    assert_nil @my_request.reload.solution
  end

  def test_solution_is_still_nil_if_404
    stub_404_odr_api_solution_request(@my_request)
    OdrFetchApiSolutionWorker.drain

    assert_equal 0, OdrCreateApiRequestWorker.jobs.size
    assert_nil @my_request.reload.solution
  end

  private

  def stub_odr_api_solution_request(my_request)
    body = { status: 'ok', code: 200, result: [1, 2, 3, 4, 6, 7] }.to_json
    actual_stub_request_odr_fetch(my_request.odr_api_uuid, 200, body)
  end

  def stub_still_computing_odr_api_solution_request(my_request)
    body = { status: 'ok', code: 200, result: "I'm still computing..." }.to_json
    actual_stub_request_odr_fetch(my_request.odr_api_uuid, 200, body)
  end

  def stub_404_odr_api_solution_request(my_request)
    body = { status: 'ok', code: 404, message: 'error' }.to_json
    actual_stub_request_odr_fetch(my_request.odr_api_uuid, 404, body)
  end

  def actual_stub_request_odr_fetch(uuid, status, body)
    url = "http://172.18.0.1:3001/api/v1/requests/#{uuid}"
    stub_request(:get, url)
      .to_return(status: status, body: body)
  end
end
