FactoryGirl.define do
  factory :photo, class: 'Photo' do
    association :photoable, factory: :product
    state 1
    file { File.open(Rails.root.join('spec', 'assets', 'cat.jpg')) }

    trait :default do
      default true
    end
  end
end
