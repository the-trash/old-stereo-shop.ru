after 'development:product_categories' do
  BRAND_COUNT = 100
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create brands',
      total: BRAND_COUNT,
      format: '%t %B %p%% %e'
    })

  brands =
    [].tap do |a|
      BRAND_COUNT.times do |n|
        a << FactoryGirl.build(:brand, {
          admin_user: admins.sample,
          state: rand(0..(Brand::STATES.count - 1)),
          position: n
        })
        progressbar.increment
      end
    end

  Brand.import(brands)
end
