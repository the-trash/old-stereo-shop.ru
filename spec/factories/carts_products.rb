FactoryGirl.define do
  factory :carts_product do
    cart
    product
    count Random.new.rand(1..7)
  end
end
