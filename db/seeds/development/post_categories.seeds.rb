after 'development:products' do
  POST_CATEGORY_COUNT = 20
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create post categories',
      total: POST_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  post_categories =
    [].tap do |a|
      POST_CATEGORY_COUNT.times do |n|
        a << FactoryGirl.build(:post_category, admin_user: admins.sample)
        progressbar.increment
      end
    end

  PostCategory.import(post_categories)

  progressbar_tree =
    ProgressBar.create({
      title: 'Make tree post categories',
      total: POST_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  all_cats = PostCategory.all

  all_cats.find_each do |category|
    new_cats =
      [].tap do |a|
        rand(3..10).times do |n|
          a << FactoryGirl.build(:post_category, {
            admin_user: admins.sample,
            state: rand(0..(Brand::STATES.count - 1)),
            parent: all_cats.sample
          })
        end
      end

    PostCategory.import(new_cats)
    progressbar_tree.increment
  end
end
