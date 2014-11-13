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

  slugs_pages = %w(about payment contacts delivery help)
  PAGES_COUNT = slugs_pages.size

  progressbar_page =
    ProgressBar.create({
      title: 'Create pages',
      total: PAGES_COUNT,
      format: '%t %B %p%% %e'
    })

  pages =
    [].tap do |a|
      slugs_pages.each do |slug|
        a << FactoryGirl.build(:page, {
            admin_user: admins.sample,
            slug: slug,
            title: I18n.t("views.pages.#{ slug }")
          })

        progressbar_page.increment
      end
    end

  Page.import(pages)
  Page.update_all(state: 1)

  # TODO: need for generate slug
  Post.find_each(&:save)
end
