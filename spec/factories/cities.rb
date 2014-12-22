FactoryGirl.define do
  factory :city do
    region
    title { Faker::Lorem.word }
  end
end
