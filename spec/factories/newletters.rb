FactoryGirl.define do
  sequence :settings do |n|
    {
      posts_count: Random.new.rand(5..20),
      only_new_posts: [true, false].sample
    }
  end

  sequence(:title) { Faker::Lorem.sentence }

  factory :newletter do
    admin_user
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
