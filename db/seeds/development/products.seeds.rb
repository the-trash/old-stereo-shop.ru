after 'development:brands' do
  PRODUCT_FACTOR = 5
  PRODUCT_COUNT  = 200
  admins = AdminUser.all
  product_categories = ProductCategory.includes(:products)
  brands = Brand.published

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

  progressbar_counters =
    ProgressBar.create({
      title: 'Update cache counters for categories',
      total: product_categories.size,
      format: '%t %B %p%% %e'
    })

  progressbar_wishes =
    ProgressBar.create({
      title: 'Generate wishes for users',
      total: User.count,
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

    product.update_column(:state, rand(0..3))

    progressbar_related_products.increment
  end

  users = User.all

  users.find_each do |user|
    products.sample(rand(1..5)).each do |product|
      user.wishes << Wish.new(product: product)
    end

    progressbar_wishes.increment
  end

  ProductCategory.reset_column_information
  product_categories.find_each do |category|
    ProductCategory.reset_counters(category.id, :products)
    category.update_attributes!({
      published_products_count: category.published_products.count,
      removed_products_count: category.removed_products.count
    })

    progressbar_counters.increment
  end
end
