class Request < ApplicationRecord
  extend Enumerize

  enumerize :request_type, in: %i[input_matrix open_street_maps]
  enumerize :algorithm_type, in: %i[greedy_algorithm]

  serialize :odr_api_matrix
  serialize :solution

  validates :request_type, presence: true
  validates :algorithm_type, presence: true
  # TODO : add validation for matrix
  validates :odr_api_path_length, presence: true,
                                  numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_number_resources,
            presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :odr_api_cycles, inclusion: { in: [true, false] }

  after_create :create_api_request

  private

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(id)
  end
end
