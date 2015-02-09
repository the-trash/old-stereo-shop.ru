FactoryGirl.define do
  factory :store do
    admin_user
    state 1
    title { generate :title }
    description { Faker::Lorem.paragraphs(Random.new.rand(2..5)).join("\r\n") }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :not_happens do
      happens false
    end

    Product::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
