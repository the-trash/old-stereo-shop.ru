class ReviewDecorator < Draper::Decorator
  delegate_all

  delegate :full_name, :email, to: :user

  def correct_user_name
    user ? (user_full_name_or_email.presence || anonymous_user) : anonymous_user
  end

  def anonymous_user
    I18n.t('anonymous_user')
  end

  private

  def user_full_name_or_email
    full_name.presence || email
  end
end
