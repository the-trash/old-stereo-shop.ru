FactoryGirl.define do
  factory :additional_option, class: 'Product::AdditionalOption' do
    product
    title { generate :title }
  end
end
