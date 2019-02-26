class OpenStreetMapRequest < ApplicationRecord
  belongs_to :request, dependent: :destroy
  has_and_belongs_to_many :tag_infos

  validates :min_longitude, presence: true
  validates :min_latitude, presence: true
  validates :max_longitude, presence: true
  validates :max_latitude, presence: true

  mount_uploader :osm_response_file, OpenStreetMapXmlUploader

  BASE_OSM_URL = 'https://api.openstreetmap.org/api/0.6/'.freeze

  # TODO : try and move to an after_create. Conflict with after_commit
  before_validation :set_matrix

  def display_name
    "Open Street Map Request ##{id}"
  end

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(request_id)
  end

  def coordinates
    parser = Nokogiri::XML.parse(osm_response_file.read)
    edges = compute_edges(parser)
    nodes = compute_nodes(edges, parser)

    fetch_coordinates(nodes)
  end

  def fetch_coordinates(nodes)
    coordinates = []

    request&.solution&.each do |s|
      coordinates << [nodes[s - 1][:lat].to_f, nodes[s - 1][:lon].to_f]
    end

    coordinates
  end

  private

  def set_matrix
    url = osm_url(min_longitude, min_latitude, max_longitude, max_latitude)
    self.remote_osm_response_file_url = url

    request.odr_api_matrix = retrieve_input_matrix
  end

  def osm_url(min_lon, min_lat, max_lon, max_lat)
    "#{BASE_OSM_URL}/map?bbox=#{min_lon},#{min_lat},#{max_lon},#{max_lat}"
  end

  def retrieve_input_matrix
    parser = Nokogiri::XML.parse(osm_response_file.read)
    edges = compute_edges(parser)
    nodes = compute_nodes(edges, parser)

    create_matrix(nodes, edges)
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

  def compute_nodes(edges, parser)
    flattened_edges = edges.flatten.uniq
    nodes = []
    parser.css(:node)
          .select { |node| flattened_edges.include?(node[:id]) }
          .each do |node|
      nodes << { id: node[:id], lat: node[:lat], lon: node[:lon] }
    end

    nodes
  end

  # TODO : fetch tags from model
  def wanted_tags?(way)
    good_tags = %w[motorway trunk primary secondary tertialy unclassified
                   residential]
    way.css(:tag).each do |tags|
      return true if tags.attributes['k'].value == 'highway' &&
                     good_tags.include?(tags.attributes['v'].value)
    end

    false
  end

  def create_matrix(nodes, edges)
    nodes_count = nodes.count
    Array.new(nodes_count) do |row|
      Array.new(nodes_count) do |col|
        if row == col
          0
        else
          edges.any? { |e| e == [nodes[row][:id], nodes[col][:id]] } ? 1 : 0
        end
      end
    end
  end
end
