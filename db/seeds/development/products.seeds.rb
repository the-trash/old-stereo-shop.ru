after 'development:brands' do
  PRODUCT_COUNT = 500
  admins = AdminUser.all
  product_categories = ProductCategory.all
  brands = Brand.all

  progressbar =
    ProgressBar.create({
      title: 'Create products',
      total: PRODUCT_COUNT,
      format: '%t %B %p%% %e'
    })

  products =
    [].tap do |a|
      PRODUCT_COUNT.times do |n|
        a << FactoryGirl.build(:product, {
          admin_user: admins.sample,
          product_category: product_categories.sample,
          brand: brands.sample,
          position: n
        })
        progressbar.increment
      end
    end

  Product.import(products)
end
