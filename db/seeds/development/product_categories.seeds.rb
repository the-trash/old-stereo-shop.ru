after 'development:users' do
  PRODUCT_CATEGORY_COUNT = 10

  progressbar =
    ProgressBar.create({
      title: 'Create product categories',
      total: PRODUCT_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  admins = AdminUser.all

  product_categories =
    [].tap do |a|
      PRODUCT_CATEGORY_COUNT.times do |n|
        a << FactoryGirl.build(:product_category, admin_user: admins.sample)
        progressbar.increment
      end
    end

  ProductCategory.import(product_categories)
end
