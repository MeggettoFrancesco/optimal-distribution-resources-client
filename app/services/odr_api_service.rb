class OdrApiService
  def initialize
    @client = client
  end

  def create_api_request(my_request); end

  def retrieve_api_request(api_request_uuid)
    url = "api/v1/requests/#{api_request_uuid}"
    response = @client.get(url)
    JSON.parse(response.body)
  end

  private

  def client
    # TODO : Update url for production
    Faraday.new(url: 'http://172.18.0.1:3001') do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded # form-encode POST params
      # faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
  end
end
