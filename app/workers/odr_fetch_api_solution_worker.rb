class OdrFetchApiSolutionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(request_id, api_request_uuid)
    response = OdrApiService.new.retrieve_api_request(api_request_uuid)
    analyze_response(response, request_id)
  rescue StandardError
    OdrFetchApiSolutionWorker.perform_in(5, request_id, api_request_uuid)
    # Exit looping if in test environment
    raise StandardError, 'Failure' if Rails.env.test?
  end

  private

  def analyze_response(response, request_id)
    case response['code']
    when 200
      solution = response['result']
      still_computing = solution == "I'm still computing..."
      raise StandardError, 'Still computing. Ask again' if still_computing

      Request.update(request_id, solution: response['result'])
    end
    # Send message to Rollbar on "else"
  end
end
