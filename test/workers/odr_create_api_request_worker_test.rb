require 'test_helper'
require 'sidekiq/testing'
require 'workers/_stub_requests'

class OdrCreateApiRequestWorkerTest < Minitest::Test
  include FactoryBot::Syntax::Methods
  include StubRequests

  def setup
    Sidekiq::Worker.clear_all
    @my_request = create(:request)
  end

  def test_request_uuid_is_updated_if_200
    stub_odr_api_request(@my_request)
    OdrCreateApiRequestWorker.drain

    assert_equal 0, OdrCreateApiRequestWorker.jobs.size
    assert @my_request.reload.odr_api_uuid.present?
  end

  def test_odr_fetch_api_solution_worker_job_is_present_if_200
    stub_odr_api_request(@my_request)
    OdrCreateApiRequestWorker.drain

    assert_equal 1, OdrFetchApiSolutionWorker.jobs.size
    assert @my_request.reload.odr_api_uuid.present?
  end

  def test_request_uuid_is_still_nil_if_404
    stub_404_odr_api_request(@my_request)
    OdrCreateApiRequestWorker.drain

    assert_equal 0, OdrCreateApiRequestWorker.jobs.size
    assert_nil @my_request.reload.odr_api_uuid
  end
end
