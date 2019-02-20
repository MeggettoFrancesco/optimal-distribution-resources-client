class OpenStreetMapRequest < ApplicationRecord
  belongs_to :request, dependent: :destroy

  validates :min_longitude, presence: true
  validates :min_latitude, presence: true
  validates :max_longitude, presence: true
  validates :max_latitude, presence: true

  def create_api_request
    OsmGetGraphWorker.perform_async(
      request_id, min_longitude, min_latitude, max_longitude, max_latitude
    )
  end
end
