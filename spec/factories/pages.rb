FactoryGirl.define do
  factory :page do
    admin_user
    post_category
    state 1
    sequence(:title) { Faker::Lorem.sentence }
    short_text { Faker::Lorem.word }
    full_text { Faker::Lorem.paragraphs(Random.new.rand(5..10)).join("\r\n") }
    meta {
      {
        keywords: Faker::Lorem.words(Random.new.rand(4..10)).join(','),
        seo_title: Faker::Lorem.sentence,
        seo_description: Faker::Lorem.sentence
      }
    }
  end
end
