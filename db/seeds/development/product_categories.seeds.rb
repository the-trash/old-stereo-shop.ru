after 'development:users' do
  PRODUCT_CATEGORY_COUNT = 10
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create product categories',
      total: PRODUCT_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  product_categories =
    [].tap do |a|
      PRODUCT_CATEGORY_COUNT.times do |n|
        a << FactoryGirl.build(:product_category, admin_user: admins.sample)
        progressbar.increment
      end
    end

  ProductCategory.import(product_categories)

  progressbar_tree =
    ProgressBar.create({
      title: 'Make tree product categories',
      total: PRODUCT_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  all_cats = ProductCategory.all

  all_cats.find_each do |category|
    new_cats =
      [].tap do |a|
        rand(3..10).times do |n|
          a << FactoryGirl.build(:product_category, {
            admin_user: admins.sample,
            parent: all_cats.sample
          })
        end
      end

    ProductCategory.import(new_cats)
    progressbar_tree.increment
  end

  ProductCategory.find_each do |category|
    category.update_column(:state, rand(0..3))
  end
end
