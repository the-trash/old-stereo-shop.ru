FactoryGirl.define do
  factory :post do
    admin_user { FactoryGirl.shared_admin }
    post_category
    state 1
    title { generate :title }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    full_text { Faker::Lorem.paragraphs(Random.new.rand(5..10)).join("\r\n") }
    meta { generate :meta }

    Post::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
