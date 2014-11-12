after 'development:products' do
  POST_CATEGORY_COUNT = 5
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create post categories',
      total: POST_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  post_categories =
    [].tap do |a|
      (POST_CATEGORY_COUNT - 3).times do |n|
        a << FactoryGirl.build(:post_category, admin_user: admins.sample)
        progressbar.increment
      end

      ['Новости', 'Полезная информация', 'Кто мы'].each_with_index do |custom_title, index|
        a << FactoryGirl.build(:post_category, admin_user: admins.sample, title: custom_title, page_position: index)
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
            parent: all_cats.sample
          })
        end
      end

    PostCategory.import(new_cats)
    progressbar_tree.increment
  end

  PostCategory.all.find_each do |category|
    category.update_column(:state, rand(0..3))
  end
end
