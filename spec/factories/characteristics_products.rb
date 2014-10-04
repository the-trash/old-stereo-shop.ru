FactoryGirl.define do
  factory :characteristics_product do
    characteristic
    product
    value { Random.new.rand(10..50) }
  end
end
