FactoryGirl.define do
  factory :product do
    admin_user
    product_category
    brand
    sequence(:title) { Faker::Commerce.product_name }
    sku { Faker::Code.isbn(Random.new.rand(5..8)) }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    price { Random.new.rand(10..100) }
    discount { Random.new.rand(0..9) }
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
