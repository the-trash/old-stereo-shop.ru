after 'development:brands' do
  PRODUCT_FACTOR = 5
  PRODUCT_COUNT  = 100
  admins = AdminUser.all
  product_categories = ProductCategory.all
  brands = Brand.all

  progressbar =
    ProgressBar.create({
      title: 'Create products',
      total: PRODUCT_FACTOR * PRODUCT_COUNT,
      format: '%t %B %p%% %e'
    })

  progressbar_related_products =
    ProgressBar.create({
      title: 'Generate related and similar products',
      total: PRODUCT_FACTOR * PRODUCT_COUNT,
      format: '%t %B %p%% %e'
    })

  i = 0
  PRODUCT_FACTOR.times do |n|
    products =
      [].tap do |a|
        PRODUCT_COUNT.times do |n|
          a << FactoryGirl.build(:product, {
            admin_user: admins.sample,
            product_category: product_categories.sample,
            brand: brands.sample,
            position: i
          })

          progressbar.increment
          i += 1
        end
      end

    Product.import(products)
  end

  products = Product.all

  products.find_each do |product|
    products.sample(rand(0..4)).each do |related|
      product.related_products << related
    end

    products.sample(rand(0..4)).each do |similar|
      product.similar_products << similar
    end

    progressbar_related_products.increment
  end
end
