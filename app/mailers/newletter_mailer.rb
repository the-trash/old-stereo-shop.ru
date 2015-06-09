class NewletterMailer < ActionMailer::Base
  default from: Setting.find_by(key: 'shop_from_email') || Settings.shop.default.from

  def newletter(user, newletter)
    @posts =
      newletter.post_category.posts.published.
      limit(newletter.posts_count.presence || Settings.pagination.posts).
      order(created_at: (newletter.only_new_posts ? :desc : :asc))

    @user = user

    mail(to: user.email, subject: newletter.title.presence || Settings.newletter.subject)
  end
end
