FactoryGirl.define do
  factory :newletter do
    admin_user { FactoryGirl.shared_admin }
    post_category
    state 1
    subscription_type { Newletter.subscription_types.values.sample }
    title { generate :title }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    settings { generate :settings }

    Newletter::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end

    trait :posts_count_zero do
      settings { generate(:settings).merge posts_count: 0 }
    end
  end
end
