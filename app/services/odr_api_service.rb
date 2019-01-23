class OdrApiService
  BASE_URL = 'api/v1/requests'.freeze

  def initialize
    @client = client
  end

  def create_api_request(**params)
    json_api_params = generate_message_params(params)
    response = @client.post(BASE_URL, json_api_params)
    JSON.parse(response.body)
  end

  def retrieve_api_request(api_request_uuid)
    url = "#{BASE_URL}/#{api_request_uuid}"
    response = @client.get(url)
    JSON.parse(response.body)
  end

  private

  def client
    Faraday.new(url: 'http://172.18.0.1:3001') do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      # faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter
    end
  end

  def generate_message_params(params)
    {
      request: {
        request_type: params[:request_type],
        algorithm_parameters: algorithm_parameters(params)
      }
    }
  end

  def algorithm_parameters(params)
    {
      input_matrix: params[:input_matrix],
      path_length: params[:path_length],
      number_resources: params[:number_resources],
      cycles: params[:cycles]
    }
  end
end
