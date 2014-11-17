class Users::PasswordsController < Devise::PasswordsController
  before_filter :add_needed_breadcrumbs

  def new
    add_breadcrumb I18n.t('views.users.password.recover'), [:new, :user, :password]
    super
  end

  private

  def add_needed_breadcrumbs
    if user_signed_in?
      add_breadcrumb I18n.t('views.users.profile'), current_user
    else
      add_breadcrumb I18n.t('authentication'), [:new, :user, :session]
    end
  end
end
