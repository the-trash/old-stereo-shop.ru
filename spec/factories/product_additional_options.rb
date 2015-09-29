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

    trait :select_type do
      render_type :select_style
    end

    trait :radio_type do
      render_type :radio
    end

    factory :option_like_select_style, traits: [:select_type]
    factory :option_like_radio_type, traits: [:radio_type]
  end
end
