require 'test_helper'

class OpenStreetMapXmlUploaderTest < ActiveSupport::TestCase
  setup do
    OpenStreetMapXmlUploader.enable_processing = true

    request = build(:request, request_type: :open_street_map_request)
    @osm_request = request.open_street_map_request
    stub_osm_api_request(@osm_request)

    path = Rails.root.join('test', 'factories', 'files', 'map.osm')
    @osm_request.osm_response_file = path.open
    @osm_request.save!
  end

  test 'content type should be application/xml' do
    skip
    assert_equal('application/xml', @osm_request.osm_response_file.content_type)
  end

  test 'osm_response_file path should be present' do
    assert @osm_request.osm_response_file.path.present?
  end
end
