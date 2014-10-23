FactoryGirl.define do
  factory :review do
    user
    rating
    body { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    pluses { Faker::Lorem.sentence }
    cons { Faker::Lorem.sentence }
    association :recallable, factory: :product

    Review::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end

    # trait :for_post do
    #   association :recallable, factory: :post
    # end
  end
end