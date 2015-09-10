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
    terms_of_service true

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

    trait :with_line_items do
      transient do
        line_item nil
      end

      after :create do |order, evaluator|
        if evaluator.line_item
          order.line_items << evaluator.line_item
        else
          create_list :line_item, 1, order: order
        end
      end
    end
  end
end
