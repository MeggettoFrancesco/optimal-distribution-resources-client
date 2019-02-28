FactoryBot.define do
  factory :request do
    request_type { Request.request_type.values.sample }
    algorithm_type { Request.algorithm_type.values.sample }
    odr_api_matrix { create_matrix }
    odr_api_path_length { rand(2..10) }
    odr_api_number_resources { rand(1..10) }
    odr_api_cycles { Faker::Boolean.boolean }
    # odr_api_uuid {  }

    after(:build) do |request|
      build(request.request_type.to_sym, request: request)
    end
  end
end

def create_matrix
  size = rand(4..25)

  Array.new(size) do |row|
    Array.new(size) do |col|
      if row == col
        0
      else
        [0, 1].sample
      end
    end
  end
end
