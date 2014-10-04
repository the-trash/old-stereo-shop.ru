FactoryGirl.define do
  factory :products_store do
    store
    product
    count { Random.new.rand(10..50) }
  end
end
