FactoryGirl.define do
  factory :brand do
    admin_user
    sequence(:title) { Faker::Lorem.word }
    description { Faker::Lorem.paragraphs(Random.new.rand(4..8)).join("\r\n") }
    site_link { Faker::Internet.url(Faker::Lorem.word + Faker::Internet.domain_name) }
    state 1

    meta { generate :meta }

    Brand::STATES.each_with_index do |s, i|
      trait s do
        state i
      end
    end
  end
end
