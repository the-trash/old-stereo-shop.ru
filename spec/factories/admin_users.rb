FactoryGirl.define do
  factory :admin_user do
    email Faker::Internet.free_email
    password '12345678'
    password_confirmation '12345678'
  end
end
