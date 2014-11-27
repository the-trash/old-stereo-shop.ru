FactoryGirl.define do
  factory :cart do
    user
    session_token SecureRandom.urlsafe_base64(nil, false)

    trait :with_products do
      after(:create) do |cart|
        cart.carts_products << create_list(:carts_product, 3, cart: cart)
      end
    end
  end
end
