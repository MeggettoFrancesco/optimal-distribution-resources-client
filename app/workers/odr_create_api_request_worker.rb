class OdrCreateApiRequestWorker
  include Sidekiq::Worker

  def perform(request_id)
    my_request = Request.find_by_id(request_id)

    odr_api_service = OdrApiService.new
    response = odr_api_service.create_api_request(
      request_type: my_request.algorithm_type,
      input_matrix: '[[0, 1, 0, 0], [1, 0, 1, 1], [0, 1, 0, 1], [0, 1, 1, 0]]',
      path_length: my_request.odr_api_path_length,
      number_resources: my_request.odr_api_number_resources,
      cycles: my_request.odr_api_cycles
    )
    analyze_response(response, request_id)
  end

  private

  def analyze_response(response, request_id)
    case response['code']
    when 200
      api_uuid = response['request_uuid']
      Request.update(request_id, odr_api_uuid: api_uuid)

      # Run second worker and fetch the solution
      OdrFetchApiSolutionWorker.perform_async(request_id, api_uuid)
    else
      p 'SEND MESSAGE TO ROLLBAR'
      p response
      # Send message to Rollbar
    end
  end
end
