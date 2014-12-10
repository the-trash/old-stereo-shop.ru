after 'development:posts' do
  admins = AdminUser.all
  post_categories = PostCategory.published

  NEWLETTERS_COUNT = 20

  progressbar =
    ProgressBar.create({
      title: 'Create newletters',
      total: NEWLETTERS_COUNT,
      format: '%t %B %p%% %e'
    })

  newletters =
    [].tap do |a|
      NEWLETTERS_COUNT.times do |n|
        a << FactoryGirl.build(:newletter, {
          admin_user: admins.sample,
          post_category: post_categories.sample
        })

        progressbar.increment
      end
    end

  Newletter.import(newletters)

  Newletter.find_each do |newletter|
    newletter.update_attributes(state: 1, subscription_type: Newletter.subscription_types.values.sample)
  end
end
