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

  [true, false].each do |happens|
    stores =
      [].tap do |a|
        STORE_COUNT.times do |n|
          a << FactoryGirl.build(:store, {
              admin_user: admins.sample,
              position: n,
              happens: happens
            })

          progressbar.increment
        end
      end

    Store.import(stores)
  end

  # stores = Store.all_happens

  # PRODUCTS_FACTOR.times do |n|
  #   products_stores =
  #     [].tap do |a|
  #       Product.limit(PRODUCTS_COUNT).offset(n * PRODUCTS_FACTOR).each do |product|
  #         a <<
  #           [].tap do |b|
  #             rand(0..5).times do |n|
  #               b << ProductsStore.new({
  #                 product: product,
  #                 store: stores.sample,
  #                 count: rand(0..50)
  #               })
  #             end
  #           end
  #       end

  #       a.flatten.uniq! { |p_s| p_s.store_id }
  #     end

  #   ProductsStore.import(products_stores.flatten)
  #   progressbar_products_stores.increment
  # end
end
