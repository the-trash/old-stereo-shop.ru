FactoryGirl.define do
  factory :product_category do
    admin_user
    sequence(:title) { Faker::Lorem.sentence }
    state 1
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    meta {
      {
        keywords: Faker::Lorem.words(Random.new.rand(4..10)).join(','),
        seo_title: Faker::Lorem.sentence,
        seo_description: Faker::Lorem.sentence
      }
    }

    ProductCategory::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
