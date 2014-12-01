FactoryGirl.define do
  factory :line_item do
    cart
    product
    quantity Random.new.rand(1..7)
  end
end
