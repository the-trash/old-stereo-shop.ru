FactoryGirl.define do
  factory :brand do
    admin_user
    sequence(:title) { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    site_link { Faker::Internet.url(Faker::Lorem.word + Faker::Internet.domain_name) }
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
