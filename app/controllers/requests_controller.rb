class RequestsController < ApplicationController
  def index
    redirect_to new_request_path
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.create(request_params)

    render :new unless @request.save
  end

  private

  def request_params
    params.require(:request)
          .permit(:request_type, :algorithm_type, :odr_api_path_length,
                  :odr_api_number_resources, :odr_api_cycles)
  end
end
