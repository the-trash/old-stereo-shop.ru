FactoryGirl.define do
  factory :product_import, class: 'Product::Import' do
    admin_user { FactoryGirl.shared_admin }
    file { File.open(Rails.root.join('spec', 'assets', 'product_import.csv')) }
  end
end
