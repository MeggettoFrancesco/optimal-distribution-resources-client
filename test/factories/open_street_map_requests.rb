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
      list_tags = open_street_map_request.tag_infos
      rand(2..4).times do
        tag = new_tag
        list_tags << tag unless list_tags.include?(tag)
      end
    end
  end
end

private

def new_tag
  if TagInfo.all.present?
    TagInfo.all.sample
  else
    create(:tag_info)
  end
end
