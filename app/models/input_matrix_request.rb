class InputMatrixRequest < ApplicationRecord
  belongs_to :request

  validates :is_directed_graph, inclusion: { in: [true, false] }

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(request_id)
  end
end
