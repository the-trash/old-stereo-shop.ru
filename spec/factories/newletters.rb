FactoryGirl.define do
  factory :newletter do
    admin_user
    post_category
    state 1
    subscription_type { Newletter.subscription_types.values.sample }

    sequence(:title) { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }

    settings {
      {
        posts_count: Random.new.rand(5..20),
        only_new_posts: [true, false].sample
      }
    }

    Newletter::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
