FactoryGirl.define do
  factory :attributes_value, class: 'Product::AttributesValue' do
    association :value, factory: :additional_options_value
    new_value Faker::Lorem.word
    state 1
    product_attribute Product::ALLOWED_ATTRIBUTES.sample
  end
end
