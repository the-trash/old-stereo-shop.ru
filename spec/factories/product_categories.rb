FactoryGirl.define do
  factory :product_category do
    admin_user
    title { generate :title }
    state 1
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    meta { generate :meta }

    ProductCategory::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
