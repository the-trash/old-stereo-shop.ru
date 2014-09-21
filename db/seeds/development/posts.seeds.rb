after 'development:post_categories' do
  POST_COUNT = 250
  admins = AdminUser.all
  post_categories = PostCategory.all

  progressbar =
    ProgressBar.create({
      title: 'Create posts',
      total: POST_COUNT,
      format: '%t %B %p%% %e'
    })

  posts =
    [].tap do |a|
      POST_COUNT.times do |n|
        a << FactoryGirl.build(:post, {
          admin_user: admins.sample,
          post_category: post_categories.sample,
          position: n
        })
        progressbar.increment
      end
    end

  Post.import(posts)
end
