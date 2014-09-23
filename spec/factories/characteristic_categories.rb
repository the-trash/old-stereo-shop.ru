FactoryGirl.define do
  factory :characteristic_category do
    admin_user
    title { Faker::Lorem.sentence }
  end
end
