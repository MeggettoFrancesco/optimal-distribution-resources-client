class Request < ApplicationRecord
  extend Enumerize

  enumerize :request_type, in: %i[input_matrix open_street_maps]
  enumerize :algorithm_type, in: %i[greedy_algorithm]

  serialize :solution

  validates :request_type, presence: true
  validates :algorithm_type, presence: true
  validates :odr_api_matrix, presence: true
  validates :odr_api_path_length, presence: true,
                                  numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_number_resources,
            presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_cycles, inclusion: { in: [true, false] }

  after_commit :create_api_request, on: :create

  private

  def create_api_request
    if request_type == :open_street_maps
      min_lon = -0.153825
      min_lat = 51.509190
      max_lon = -0.148707
      max_lat = 51.513664
      OsmGetGraphWorker.perform_async(id, min_lon, min_lat, max_lon, max_lat)
    else
      OdrCreateApiRequestWorker.perform_async(id)
    end
  end
end
