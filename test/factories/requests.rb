FactoryBot.define do
  factory :request do
    request_type { Request.request_type.values.sample }
    algorithm_type { Request.algorithm_type.values.sample }
    odr_api_matrix { [] }
    odr_api_path_length { Random.rand(2..10) }
    odr_api_number_resources { Random.rand(1..10) }
    odr_api_cycles { Faker::Boolean.boolean }
    # odr_api_uuid {  }
    solution { [] }

    after(:build) do |request|
      FactoryBot.build(request.request_type.to_sym, request: request)
    end
  end
end
