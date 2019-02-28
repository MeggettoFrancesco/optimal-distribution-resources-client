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
  validate :existence_of_relationships

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

  def delete_unwanted_nested_associations
    (Request.request_type.values - [request_type]).each do |request_type|
      nested_resource = send(request_type)
      nested_resource.delete if nested_resource.present?
    end
  end

  private

  def existence_of_relationships
    other_types_not_filled_in
    selected_type_filled_in if request_type.present?
  end

  def other_types_not_filled_in
    (Request.request_type.values - [request_type]).each do |e|
      nested_model_error(:unselected_nested_model_filled_in) if send(e).present?
    end
  end

  def selected_type_filled_in
    invalid = send(request_type).present?
    nested_model_error(:nested_model_not_present) unless invalid
  end

  def nested_model_error(type)
    errors.add(:request_type, type)
  end

  def create_api_request
    send(request_type).create_api_request
  end
end
