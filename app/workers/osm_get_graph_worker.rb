class OsmGetGraphWorker
  include Sidekiq::Worker

  def perform(request_id, min_lon, min_lat, max_lon, max_lat)
    response = OsmApiService.new.graph_adjacency_matrix(
      min_lon,
      min_lat,
      max_lon,
      max_lat
    )

    # TODO : what about nodes?
    Request.update(request_id, odr_api_matrix: response[:resulting_matrix])
  end
end
