FactoryGirl.define do
  factory :wish, class: 'Wish' do
    association :user, factory: :user
    association :product, factory: :product
  end
end
