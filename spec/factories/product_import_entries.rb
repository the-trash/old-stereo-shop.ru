FactoryGirl.define do
  sequence :import_entry_data do
    {
      need_update: false,
      new_product: true,
      title: Faker::Commerce.product_name,
      sku: Faker::Code.isbn(3),
      description: Faker::Lorem.paragraph,
      stores: 'Store 1:12;Store 2:1',
      meta: 'keywords:bla bla|bla b|asd;seo_description:bla la;seo_title:asfsdf',
      brand: 'Brand',
      price: '10',
      discount: '1'
    }
  end

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
      data FactoryGirl.generate(:import_entry_data).merge(need_update: true)
      stores 'Store 2:123'
      price '11'
      discount '2'
      meta 'keywords:bla1 bla2|asd;seo_description:bla2;seo_title:asfsdf12'
    end
  end
end
