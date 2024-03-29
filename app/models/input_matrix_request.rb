class InputMatrixRequest < ApplicationRecord
  belongs_to :request, dependent: :destroy

  attr_accessor :matrix_size

  validates :is_directed_graph, inclusion: { in: [true, false] }

  def create_api_request
    OdrCreateApiRequestWorker.perform_async(request_id)
  end

  def coordinates
    request.solution
  end
end
