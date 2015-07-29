FactoryGirl.define do
  sequence :settings do |n|
    {
      posts_count: Random.new.rand(5..20),
      only_new_posts: [true, false].sample
    }
  end

  sequence(:title) { Faker::Lorem.sentence }

  sequence :meta do
    {
      keywords: Faker::Lorem.words(Random.new.rand(4..10)).join(','),
      seo_title: Faker::Lorem.sentence,
      seo_description: Faker::Lorem.sentence
    }
  end

  sequence :properties do
    {
      weight: Random.new.rand(50..200)
    }
  end

  sequence :subscription_settings do
    {
      unsubscribe: [true, false].sample,
      news: [true, false].sample,
      bonus: [true, false].sample,
      product_delivered: [true, false].sample,
      deals: [true, false].sample
    }
  end
end
