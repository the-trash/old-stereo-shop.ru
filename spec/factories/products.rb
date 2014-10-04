FactoryGirl.define do
  factory :product do
    admin_user
    product_category
    brand
    state 1
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

    Product::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end

    trait :with_caracteristics do
      after(:create) do |product|
        product.characteristics_products << create_list(:characteristics_product, 3, product: product)
      end
    end

    trait :with_stores do
      after(:create) do |product|
        product.products_stores << create_list(:products_store, 3, product: product)
      end
    end

    trait :with_related do
      association :related_products, factory: :product
    end

    trait :with_similar do
      association :similar_products, factory: :product
    end
  end
end
