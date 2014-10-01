after 'development:posts' do
  STORE_COUNT = 5
  PRODUCTS_FACTOR = 5
  PRODUCTS_COUNT = Product.count / PRODUCTS_FACTOR

  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create stores',
      total: 2 * STORE_COUNT,
      format: '%t %B %p%% %e'
    })

  progressbar_products_stores =
    ProgressBar.create({
      title: 'Create relation products <-> stores',
      total: STORE_COUNT,
      format: '%t %B %p%% %e'
    })

  i = 0
  [true, false].each do |happens|
    stores =
      [].tap do |a|
        STORE_COUNT.times do |n|
          a << FactoryGirl.build(:store, {
              admin_user: admins.sample,
              position: i,
              happens: happens
            })

          progressbar.increment
          i += 1
        end
      end

    Store.import(stores)
  end

  products = Product.all

  Store.products_are.find_each do |store|
    product_ids = products.sample(rand((products.size / (2 * STORE_COUNT))..products.size)).map(&:id)
    products_stores_product_ids = ProductsStore.where(store_id: store.id).map(&:product_id)

    products_stores =
      [].tap do |a|
        (product_ids - products_stores_product_ids).each do |p_id|
          a << ProductsStore.new({
              product_id: p_id,
              store: store,
              count: rand(0..50)
            })
        end
      end

    ProductsStore.import(products_stores)
    progressbar_products_stores.increment
  end
end
