FactoryGirl.define do
  factory :cart do
    user
    session_token SecureRandom.urlsafe_base64(nil, false)

    trait :with_products do
      after(:create) do |cart|
        cart.line_items << create_list(:line_item, 3, cart: cart)
      end
    end
  end
end
