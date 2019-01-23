class Request < ApplicationRecord
  extend Enumerize

  enumerize :request_type, in: %i[input_matrix open_street_maps]
  enumerize :algorithm_type, in: %i[greedy]

  serialize :odr_api_matrix
  serialize :solution

  validates :request_type, presence: true
  validates :algorithm_type, presence: true

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(id)
  end

  def fetch_api_solution
    example_id = '2a28e8b2-559b-48c6-864e-0c1685ecb0d2'
    OdrGetApiSolutionWorker.perform_async(id, example_id)
  end
end
