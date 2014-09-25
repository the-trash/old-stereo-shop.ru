FactoryGirl.define do
  factory :rating do
    score { Random.new.rand(1..5) }
    user
    association :votable, factory: :product
  end
end
