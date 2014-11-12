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

  PAGE_COUNT = 14
  top_menu_cat = PostCategory.top_menu.first
  who_are_we_cat = PostCategory.who_are_we.first
  convenience_and_safety_cat = PostCategory.convenience_and_safety.first

  progressbar_page =
    ProgressBar.create({
      title: 'Create pages',
      total: PAGE_COUNT,
      format: '%t %B %p%% %e'
    })

  top_menu =
    [].tap do |a|
      6.times do |n|
        a << FactoryGirl.build(:page, {
          admin_user: admins.sample,
          post_category: top_menu_cat,
          position: n
        })

        progressbar_page.increment
      end
    end

  Page.import(top_menu)

  who_are_we =
    [].tap do |a|
      5.times do |n|
        a << FactoryGirl.build(:page, {
          admin_user: admins.sample,
          post_category: who_are_we_cat,
          position: n
        })

        progressbar_page.increment
      end
    end

  Page.import(who_are_we)

  convenience_and_safety =
    [].tap do |a|
      3.times do |n|
        a << FactoryGirl.build(:page, {
          admin_user: admins.sample,
          post_category: convenience_and_safety_cat,
          position: n
        })

        progressbar_page.increment
      end
    end

  Page.import(convenience_and_safety)
end
