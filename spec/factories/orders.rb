FactoryGirl.define do
  factory :order do
    user
    city
    cart
    user_name { [Faker::Name.first_name, Faker::Name.last_name].join(' ') }
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_name }
    post_index { Faker::Address.postcode }

    trait :delivery_by_mail do
      delivery 2
    end
  end
end
