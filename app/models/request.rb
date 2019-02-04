class Request < ApplicationRecord
  extend Enumerize

  enumerize :request_type, in: %i[input_matrix open_street_maps]
  enumerize :algorithm_type, in: %i[greedy_algorithm]

  serialize :solution

  validates :request_type, presence: true
  validates :algorithm_type, presence: true
  # TODO : add validation for matrix
  validates :odr_api_path_length, presence: true,
                                  numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_number_resources,
            presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_cycles, inclusion: { in: [true, false] }

  after_commit :retrieve_osm_matrix, if: :open_street_maps?, on: :create
  after_commit :create_api_request

  private

  def open_street_maps?
    request_type == :open_street_maps
  end

  def retrieve_osm_matrix
    OsmGetGraphWorker.perform_async(id, -0.153825, 51.509190, -0.148707, 51.513664)
  end

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(id)
  end
end
