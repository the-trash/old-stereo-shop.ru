after 'development:products' do
  POST_CATEGORY_COUNT = 10
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
end
