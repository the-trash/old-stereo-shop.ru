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
    meta { generate :meta }

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

    trait :popular do
      average_score 1000
    end

    trait :cheap do
      discount 10
      price 11
    end
  end
end
