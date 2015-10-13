FactoryGirl.define do
  factory :characteristic_category do
    admin_user { FactoryGirl.shared_admin }
    title { Faker::Lorem.sentence }
  end
end
