FactoryGirl.define do
  factory :additional_option, class: 'Product::AdditionalOption' do
    product
    title { generate :title }

    trait :with_additional_value do
      after(:create) do |additional_option|
        FactoryGirl.create \
          :additional_options_value,
          product_additional_option_id: additional_option.id
      end
    end
  end
end
