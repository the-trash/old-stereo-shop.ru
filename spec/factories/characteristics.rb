FactoryGirl.define do
  factory :characteristic do
    characteristic_category
    title { Faker::Lorem.sentence }
    unit { Faker::Lorem.word }
  end
end
