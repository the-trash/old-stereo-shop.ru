FactoryGirl.define do
  factory :order do
    user
    city
    cart
    email { Faker::Internet.email }
    user_name { [Faker::Name.first_name, Faker::Name.last_name].join(' ') }
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_name }
    post_index { Faker::Address.postcode }

    trait :with_email do
      before :create do |order|
        order.email = order.user.email
      end
    end

    trait :delivery_by_mail do
      delivery 2
    end

    trait :approved do
      state 'approved'
    end

    trait :without_user do
      user_id nil
    end

    trait :without_email do
      email nil
    end
  end
end
