FactoryGirl.define do
  factory :cart do
    user
    session_token SecureRandom.urlsafe_base64(nil, false)

    trait :with_products do
      after(:create) do |cart|
        cart.line_items << create_list(:line_item, 3, cart: cart)
      end
    end

    trait :without_user do
      user_id nil
    end

    trait :with_order do
      after :create do |cart, evaluator|
        create :order, cart: cart
      end
    end

    trait :broken_relation_with_order do
      after :create do |cart, evaluator|
        order = create :order, cart: cart
        order.update_column :cart_id, nil
      end
    end

    trait :old_cart do
      updated_at 15.days.ago
    end
  end
end
