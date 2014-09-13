# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |n| Faker::Lorem.word + n.to_s }
    sequence(:value) { Faker::Name.name }
    sequence(:description) { Faker::Company.catch_phrase }
    group "group"
  end
end
