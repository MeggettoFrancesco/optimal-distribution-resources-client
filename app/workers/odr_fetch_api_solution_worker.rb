class OdrFetchApiSolutionWorker
  include Sidekiq::Worker

  def perform(request_id, api_request_uuid)
    response = OdrApiService.new.retrieve_api_request(api_request_uuid)
    analyze_response(response, request_id)
  end

  private

  def analyze_response(response, request_id)
    case response['code']
    when 200
      Request.update(request_id, solution: response['result'])
    else
      p 'SEND MESSAGE TO ROLLBAR'
      p response
      # Send message to Rollbar
    end
  end
end
