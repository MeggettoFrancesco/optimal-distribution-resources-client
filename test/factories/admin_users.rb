FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.safe_email }
    password 'password'
    password_confirmation 'password'
    website { Website.all.try(:sample) || FactoryBot.build(:website) }
  end
end
