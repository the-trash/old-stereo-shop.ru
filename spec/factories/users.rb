# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.free_email }
    password 12345678
    sequence(:birthday) { Random.new.rand(40.years).seconds.ago }
    phone { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { [nil, Faker::Name.suffix].sample }
    city { [0, 1].sample }
    index { Random.new.rand(100..1000) }
    address { Faker::Address.street_name }
    subscription_settings {
      {
        unsubscribe: [true, false].sample,
        news: [true, false].sample,
        bonus: [true, false].sample,
        product_delivered: [true, false].sample,
        deals: [true, false].sample
      }
    }
  end
end
