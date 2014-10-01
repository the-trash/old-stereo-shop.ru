USERS_COUNT  = 30
ADMINS_COUNT = 15

admin_progressbar =
  ProgressBar.create({
    title: 'Create admins',
    total: ADMINS_COUNT,
    format: '%t %B %p%% %e'
  })

user_progressbar =
  ProgressBar.create({
    title: 'Create users',
    total: USERS_COUNT,
    format: '%t %B %p%% %e'
  })

admins =
  [].tap do |a|
    ADMINS_COUNT.times do |n|
      a << FactoryGirl.build(:admin_user)
      admin_progressbar.increment
    end
  end

users =
  [].tap do |a|
    USERS_COUNT.times do |n|
      a << FactoryGirl.build(:user)
      user_progressbar.increment
    end

    a.uniq!{ |u| u.email }
  end

AdminUser.import(admins, validate: false)
User.import(users, validate: false)
