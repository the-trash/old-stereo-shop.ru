FactoryGirl.define do
  factory :additional_options_value, class: 'Product::AdditionalOptionsValue' do
    association :additional_option, factory: :additional_option
    value Faker::Lorem.word
    state 1
  end
end
