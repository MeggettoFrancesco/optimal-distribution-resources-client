FactoryBot.define do
  factory :tag_info do
    tag_key { Faker::Lorem.word }
    tag_value { Faker::Lorem.word }
  end
end
