FactoryGirl.define do
  factory :post do
    admin_user
    post_category
    sequence(:title) { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    full_text { Faker::Lorem.paragraphs(Random.new.rand(5..10)).join("\r\n") }
    meta {
      {
        keywords: Faker::Lorem.words(Random.new.rand(4..10)).join(','),
        seo_title: Faker::Lorem.sentence,
        seo_description: Faker::Lorem.sentence
      }
    }

    trait :draft do
      state 0
    end

    trait :removed do
      state 2
    end
  end
end
