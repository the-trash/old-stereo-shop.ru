FactoryGirl.define do
  factory :post_category do
    admin_user { FactoryGirl.shared_admin }
    sequence(:title) { Faker::Lorem.sentence }
    state 1
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    meta { generate :meta }

    PostCategory::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end

    trait :news do
      title I18n.t('news')
    end

    trait :useful_information do
      title I18n.t('useful_information')
    end
  end
end
