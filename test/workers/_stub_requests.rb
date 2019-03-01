module StubRequests
  def stub_odr_api_request(my_request)
    body = { status: 'ok', code: 200, request_uuid: SecureRandom.uuid }.to_json
    actual_stub_request_odr_create(my_request, 200, body)
  end

  def stub_404_odr_api_request(my_request)
    body = { status: 'error', code: 404, message: 'error' }.to_json
    actual_stub_request_odr_create(my_request, 404, body)
  end

  private

  def actual_stub_request_odr_create(my_request, status, body)
    params = odr_api_request_parameters(my_request)
    stub_request(:post, 'http://172.18.0.1:3001/api/v1/requests')
      .with(body: { request: params })
      .to_return(status: status, body: body)
  end

  def odr_api_request_parameters(my_request)
    {
      algorithm_parameters: {
        cycles: my_request.odr_api_cycles,
        input_matrix: my_request.odr_api_matrix,
        number_resources: my_request.odr_api_number_resources,
        path_length: my_request.odr_api_path_length
      },
      request_type: my_request.algorithm_type
    }
  end
end
