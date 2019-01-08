FactoryBot.define do
  factory :request do
    request_type { Request.request_type.values.sample }
    algorithm_type { Request.algorithm_type.values.sample }
  end
end
