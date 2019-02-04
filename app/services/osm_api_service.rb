require 'matrix'

class OsmApiService
  BASE_URL = 'https://api.openstreetmap.org/api/0.6/'.freeze

  attr_reader :nodes
  attr_reader :edges

  def initialize
    @client = client
  end

  def graph_adjacency_matrix(min_lon, min_lat, max_lon, max_lat)
    url = "#{BASE_URL}/map?bbox=#{min_lon},#{min_lat},#{max_lon},#{max_lat}"
    response = @client.get(url)

    parser = Nokogiri::XML.parse(response.body)
    @edges = compute_edges(parser)
    @nodes = compute_nodes(parser)

    resulting_matrix = create_matrix

    { resulting_matrix: resulting_matrix, nodes: @nodes }
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
    edges = []
    parser.css(:way).each do |way|
      next unless wanted_tags?(way)

      nds = way.css(:nd)
      nds.each_cons(2) { |curr, nekst| edges << [curr[:ref], nekst[:ref]] }
    end

    edges
  end

  def compute_nodes(parser)
    flattened_edges = @edges.flatten.uniq
    nodes = []
    parser.css(:node)
          .select { |node| flattened_edges.include?(node[:id]) }
          .each do |node|
      nodes << { id: node[:id], lat: node[:lat], lon: node[:lon] }
    end

    nodes
  end

  def wanted_tags?(way)
    good_tags = %w[motorway trunk primary secondary tertialy residential]
    way.css(:tag).each do |tags|
      return true if tags.attributes['k'].value == 'highway' &&
                     good_tags.include?(tags.attributes['v'].value)
    end

    false
  end

  def create_matrix
    Array.new(@nodes.count) do |row|
      Array.new(@nodes.count) do |col|
        if row == col
          0
        else
          @edges.any? { |e| e == [@nodes[row][:id], @nodes[col][:id]] } ? 1 : 0
        end
      end
    end
  end
end
