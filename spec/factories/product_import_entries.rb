FactoryGirl.define do
  factory :product_import_entry, class: 'Product::ImportEntry' do
    association :import, factory: :product_import
    data { generate(:import_entry_data) }

    after(:build) do |import_entry|
      ['Store 1', 'Store 2'].each do |store_title|
        create :store, title: store_title
      end

      create :brand, title: 'Brand'
    end

    trait :need_update do
      data { generate(:import_entry_data).merge(need_update: true) }
      stores 'Store 2:123'
      price '11'
      discount '2'
      euro_price '6'
      meta 'keywords:bla1 bla2|asd;seo_description:bla2;seo_title:asfsdf12'
    end

    trait :without_stores do
      stores nil
    end

    trait :without_brand do
      brand nil
    end
  end
end
