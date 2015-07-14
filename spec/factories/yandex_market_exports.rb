FactoryGirl.define do
  factory :yandex_market_export do
    trait :without_file do
      state 'started'
      file nil
    end
  end
end
