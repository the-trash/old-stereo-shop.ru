FactoryGirl.define do
  factory :seo_setting do
    controller_name 'brands'
    action_name 'index'
    seo_title Faker::Lorem.word
    seo_description Faker::Lorem.word
    keywords Faker::Lorem.word

    trait :empty do
      controller_name nil
      action_name nil
    end

    trait :without_url do
      url nil
    end

    trait :with_url do
      url '/brands'
    end
  end
end
