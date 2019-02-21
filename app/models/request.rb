class Request < ApplicationRecord
  extend Enumerize

  has_one :input_matrix_request
  has_one :open_street_map_request

  accepts_nested_attributes_for :input_matrix_request, allow_destroy: true,
                                                       reject_if: :all_blank
  accepts_nested_attributes_for :open_street_map_request, allow_destroy: true,
                                                          reject_if: :all_blank

  enumerize :request_type, in: %i[input_matrix_request open_street_map_request]
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

  def build_nested_associations
    Request.request_type.values.each do |request_type|
      send("build_#{request_type}")
    end
  end

  def coordinates
    send(request_type).coordinates
  end

  def input_matrix_request?
    request_type == :input_matrix_request
  end

  def open_street_map_request?
    request_type == :open_street_map_request
  end

  private

  def create_api_request
    send(request_type).create_api_request
  end
end
