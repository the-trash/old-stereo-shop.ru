FactoryGirl.define do
  factory :carts_product do
    cart
    product
    quantity Random.new.rand(1..7)
  end
end
