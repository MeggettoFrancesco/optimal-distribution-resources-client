class OdrGetApiSolutionWorker
  include Sidekiq::Worker

  def perform(request_id, api_request_uuid)
    response = OdrApiService.new.retrieve_api_request(api_request_uuid)
    Request.update(request_id, solution: analyze_response(response))
  end

  def analyze_response(response)
    case response['code']
    when 200
      response['result']
    else
      p 'SEND MESSAGE TO ROLLBAR'
      # Send message to Rollbar
    end
  end
end
