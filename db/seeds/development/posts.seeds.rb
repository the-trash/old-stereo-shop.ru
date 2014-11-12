after 'development:post_categories' do
  POST_COUNT = 1000
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

  Post.all.find_each do |post|
    post.update_column(:state, rand(0..3))
  end

  pages_title = ['О нас', 'Контакты', 'Оплата', 'Доставка', 'Помощь и обратная связь']
  PAGES_COUNT = pages_title.size

  progressbar_page =
    ProgressBar.create({
      title: 'Create pages',
      total: PAGES_COUNT,
      format: '%t %B %p%% %e'
    })

  pages =
    [].tap do |a|
      pages_title.each do |title|
        a << FactoryGirl.build(:page, admin_user: admins.sample, title: title)

        progressbar_page.increment
      end
    end

  Page.import(pages)
end
