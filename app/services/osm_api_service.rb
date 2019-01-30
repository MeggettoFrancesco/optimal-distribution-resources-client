class OsmApiService
  BASE_URL = 'https://api.openstreetmap.org/api/0.6/'.freeze

  def initialize
    @client = client
  end

  # OsmApiService.new.graph_adjacency_matrix(-0.153825,51.509190,-0.148707,51.513664)
  def graph_adjacency_matrix(min_lon, min_lat, max_lon, max_lat)
    url = "#{BASE_URL}/map?bbox=#{min_lon},#{min_lat},#{max_lon},#{max_lat}"
    response = @client.get(url)

    parser = Nokogiri::XML.parse(response.body)
    edges = compute_edges(parser)
    nodes = compute_nodes(parser, edges)

    # nodes.map { |c| puts "#{c[:lat]}, #{c[:lon]}" }.count
    byebug
  end

  private

  def client
    Faraday.new(url: BASE_URL) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      # faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter
    end
  end

  def compute_edges(parser)
    counter = {}

    parser.css(:way).each do |way|
      next unless good_tags?(way)

      way.css(:nd).each do |nd|
        counter[nd[:ref]] ||= 0
        counter[nd[:ref]] += 1
      end
    end

    # Find edges that are shared with 1+ nodes
    counter.select { |_, v| v > 1 }.keys
  end

  def compute_nodes(parser, edges)
    nodes = []
    parser.css(:node)
          .select { |node| edges.include?(node[:id]) }
          .each do |node|
      nodes << { lat: node[:lat], lon: node[:lon] }
    end

    nodes
  end

  def good_tags?(way)
    way.css(:tag).each do |tags|
      return true if tags.attributes['k'].value == 'highway'
    end

    false
  end
end
