# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.free_email }
    password 12345678
    sequence(:birthday) { Random.new.rand(40.years).seconds.ago }
    phone Faker::PhoneNumber.cell_phone
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    middle_name Faker::Name.suffix
  end
end
