after 'development:products' do
  CHAR_CATEGORY_COUNT = 10
  admins = AdminUser.all

  progressbar =
    ProgressBar.create({
      title: 'Create characteristic categories',
      total: CHAR_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  characteristic_categories =
    [].tap do |a|
      CHAR_CATEGORY_COUNT.times do |n|
        a << FactoryGirl.build(:characteristic_category, {
          admin_user: admins.sample,
          position: n
        })
        progressbar.increment
      end
    end

  CharacteristicCategory.import(characteristic_categories)

  char_cats = CharacteristicCategory.all

  progressbar_char =
    ProgressBar.create({
      title: 'Create characteristics',
      total: CHAR_CATEGORY_COUNT,
      format: '%t %B %p%% %e'
    })

  characteristics =
    [].tap do |a|
      char_cats.each do |cat|
        rand(3..10).times do |n|
          a << FactoryGirl.build(:characteristic, {
            characteristic_category: cat,
            position: n
          })
        end

        progressbar_char.increment
      end
    end

  Characteristic.import(characteristics)
end
