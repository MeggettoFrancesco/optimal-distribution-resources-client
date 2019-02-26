class TagInfoService
  ENDPOINT_URL = 'https://taginfo.openstreetmap.org/api/4/tags/popular'.freeze

  def initialize
    @client = client
  end

  def retrieve_all_tags
    response = @client.get
    json_response = JSON.parse(response.body)['data']

    all_tags = []
    json_response.each do |item|
      all_tags << { key: item['key'], value: item['value'] }
    end

    all_tags
  end

  private

  def client
    Faraday.new(url: ENDPOINT_URL) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      # faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter
    end
  end
end
