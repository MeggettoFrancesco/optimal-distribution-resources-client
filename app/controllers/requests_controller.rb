class RequestsController < ApplicationController
  def index
    redirect_to new_request_path
  end

  def new
    @request = Request.new
    @request.build_nested_associations
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
    parse_input_mtx if params[:request][:request_type] == 'input_matrix_request'

    params.require(:request)
          .permit(custom_request_params,
                  input_matrix_request_attributes: input_matrix_request_params,
                  open_street_map_request_attributes: osm_request_params)
  end

  def parse_input_mtx
    matrix_hash = params[:request][:odr_api_matrix]
    size = params[:request][:matrix_size]
    params[:request][:odr_api_matrix] = create_matrix(matrix_hash, size).to_s
  end

  def create_matrix(matrix_hash, size)
    Array.new(size.to_i) do |row|
      Array.new(size.to_i) do |col|
        matrix_hash[row.to_s][col.to_s].to_i
      end
    end
  end

  def custom_request_params
    %i[id request_type algorithm_type odr_api_matrix odr_api_path_length
       odr_api_number_resources odr_api_cycles]
  end

  def input_matrix_request_params
    %i[id is_directed_graph]
  end

  def osm_request_params
    %i[id min_longitude min_latitude max_longitude max_latitude]
  end
end
