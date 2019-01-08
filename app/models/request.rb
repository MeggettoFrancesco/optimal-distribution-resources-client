class Request < ApplicationRecord
  extend Enumerize

  enumerize :request_type, in: %i[input_matrix open_street_maps]
  enumerize :algorithm_type, in: %i[greedy]

  validates :request_type, presence: true
  validates :algorithm_type, presence: true
end
