class RequestsController < ApplicationController
  def index
    redirect_to new_request_path
  end

  def new
    @my_request = Request.new
    @my_request.build_nested_associations
  end

  def create
    @my_request = Request.create(request_params)
    @my_request.destroy_unwanted_nested_associations

    if @my_request.save
      redirect_to @my_request
    else
      render :new
    end
  end

  def show
    @my_request = Request.find(params[:id])
    @coordinates = @my_request.coordinates
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
    %i[id is_directed_graph matrix_size]
  end

  def osm_request_params
    [
      :id, :min_longitude, :min_latitude, :max_longitude, :max_latitude,
      tag_info_ids: []
    ]
  end
end
