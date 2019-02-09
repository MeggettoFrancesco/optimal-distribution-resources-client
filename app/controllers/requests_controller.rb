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

    # Coordinates should hold nodes' number or lat/lon depending on type
    @coordinates = [[51.5124726, -0.1493685], [51.5134696, -0.1498633], [51.5132632, -0.1509248]]
  end

  private

  def request_params
    parse_input_matrix if params[:request][:request_type] == 'input_matrix'

    params.require(:request)
          .permit(:request_type, :algorithm_type, :odr_api_matrix,
                  :odr_api_path_length, :odr_api_number_resources,
                  :odr_api_cycles)
  end

  def parse_input_matrix
    matrix_hash = params[:request][:odr_api_matrix]
    size = params[:request][:matrix_size]

    odr_api_matrix = Array.new(size.to_i) do |row|
      Array.new(size.to_i) do |col|
        matrix_hash[row.to_s][col.to_s].to_i
      end
    end
    params[:request][:odr_api_matrix] = odr_api_matrix.to_s
  end
end
