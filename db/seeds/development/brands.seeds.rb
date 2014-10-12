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
          position: n
        })
        progressbar.increment
      end
    end

  Brand.import(brands)

  Brand.find_each do |brand|
    brand.update_column(:state, rand(0..3))
  end
end
