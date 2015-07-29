FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.free_email }
    password 12345678
    sequence(:birthday) { Random.new.rand(40.years).seconds.ago }
    phone { Faker::PhoneNumber.cell_phone }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { [nil, Faker::Name.suffix].sample }
    city
    index { Faker::Address.postcode }
    address { Faker::Address.street_name }
    subscription_settings { generate :subscription_settings }
  end

  trait :with_orders do
    transient do
      orders_count 2
    end

    after :create do |user, evaluator|
      create_list(:order, evaluator.orders_count, user: user)
    end
  end

  trait :with_order_was_approved do
    after :create do |user, evaluator|
      create :order, :approved, user: user
    end
  end

  trait :subscribed do
    subscription_settings {
      { unsubscribe: false }
    }
  end

  trait :unsubscribed do
    subscription_settings {
      { unsubscribe: true }
    }
  end
end
