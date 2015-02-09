FactoryGirl.define do
  factory :page do
    admin_user
    state 1
    sequence(:title) { Faker::Lorem.sentence }
    short_text { Faker::Lorem.word }
    full_text { Faker::Lorem.paragraphs(Random.new.rand(5..10)).join("\r\n") }
    meta { generate :meta }
  end
end
