class RequestsController < ApplicationController
  def index
    redirect_to new_request_path
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.create(request_params)
  end

  private

  def request_params
    params.require(:request).permit(:request_type, :algorithm_type)
  end
end
