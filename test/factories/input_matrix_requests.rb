FactoryBot.define do
  factory :input_matrix_request do
    is_directed_graph { Faker::Boolean.boolean }

    request
  end
end
