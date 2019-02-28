require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  test 'requests#inde should redirect to requests#new' do
    get requests_path
    assert_redirected_to new_request_path
  end

  test 'should requests#new' do
    get new_request_path
    assert_response :success
  end

  test 'requests#create should redirect to requests#show' do
    my_request = build(:request)
    stub_osm_api(my_request)

    post requests_path(
      request: obtain_request_only_hash(my_request)
    )

    new_request = Request.last
    assert_equal my_request.odr_api_matrix, new_request.odr_api_matrix

    assert_redirected_to request_path(id: new_request.id)
  end

  test 'requests#create should render new again if request
        in requests#create is invalid' do
    my_request = build(:request)
    my_request.odr_api_path_length = ''
    stub_osm_api(my_request)

    post requests_path(
      request: obtain_request_only_hash(my_request)
    )

    assert_response :success
  end

  test 'should home#show' do
    my_request = create(:request)
    get request_path(id: my_request)
    assert_response :success
  end

  private

  def stub_osm_api(my_request)
    osm_request = my_request.open_street_map_request
    stub_osm_api_request(osm_request) if osm_request.present?
  end

  def obtain_request_only_hash(my_request)
    request_hash = {}
    add_nested_attributes_definition!(request_hash)
    add_request_attributes!(my_request, request_hash)
    add_nested_attributes!(my_request, request_hash)

    request_hash
  end

  def add_nested_attributes_definition!(request_hash)
    Request.request_type.values.each do |request_type|
      request_hash["#{request_type}_attributes"] = {}
    end
  end

  def add_nested_attributes!(my_request, request_hash)
    my_request.send(my_request.request_type).attributes.each do |key, value|
      next if value.nil?

      request_hash["#{my_request.request_type}_attributes"][key.to_s] = value
    end

    add_tag_infos(my_request, request_hash)
  end

  def add_tag_infos(my_request, request_hash)
    return unless my_request.request_type == :open_street_map_request

    ids = my_request.open_street_map_request.tag_infos.collect do |t|
      t.id.to_s
    end
    request_hash['open_street_map_request_attributes']['tag_info_ids'] = ids
  end

  def add_request_attributes!(my_request, request_hash)
    my_request.attributes.each do |key, value|
      next if value.nil?

      if key == 'odr_api_matrix'
        parse_odr_api_matrix(key, value, request_hash)
      else
        request_hash[key] = value
      end
    end
  end

  def parse_odr_api_matrix(key, value, request_hash)
    new_matrix_hash = {}

    mtx = JSON.parse(value)
    mtx.each_with_index do |row, i|
      new_matrix_hash[i.to_s] = {}

      row.each_with_index do |col, j|
        new_matrix_hash[i.to_s][j.to_s] = col.to_s
      end
    end
    request_hash[key] = new_matrix_hash
    request_hash['input_matrix_request_attributes']['matrix_size'] = mtx.count
  end
end
