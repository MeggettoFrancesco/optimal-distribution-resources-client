FactoryBot.define do
  factory :open_street_map_request do
    min_longitude { Faker::Address.longitude }
    min_latitude { Faker::Address.latitude }
    max_longitude { min_longitude + 0.005 }
    max_latitude { min_latitude + 0.002 }
    osm_response_file do
      Rack::Test::UploadedFile.new(
        Rails.root.join('test/factories/files/map.osm'),
        'application/xml'
      )
    end

    request

    after(:build) do |open_street_map_request|
      create_all_highway_tags

      list_tags = open_street_map_request.tag_infos
      TagInfo.all.each do |new_tag|
        list_tags << new_tag
      end
    end
  end
end

private

def create_all_highway_tags
  path = Rails.root.join('test', 'factories', 'files', 'highway_tags.json')
  tags = JSON.parse(path.read)
  tags.each do |tag|
    create(:tag_info, tag_key: tag['key'], tag_value: tag['value'])
  end
end
