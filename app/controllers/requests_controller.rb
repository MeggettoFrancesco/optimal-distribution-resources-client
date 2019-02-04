class RequestsController < ApplicationController
  def index
    redirect_to new_request_path
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.create(request_params)

    if @request.save
      redirect_to @request
    else
      render :new
    end
  end

  def show
    @request = Request.find(params[:id])
  end

  private

  def request_params
    params.require(:request)
          .permit(:request_type, :algorithm_type, :odr_api_path_length,
                  :odr_api_number_resources, :odr_api_cycles)
  end
end
