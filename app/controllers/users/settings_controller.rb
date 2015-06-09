class Users::SettingsController < UsersController
  before_action :check_access
  before_filter :add_profile_breadcrumbs

  def profile
    add_breadcrumb I18n.t('views.users.settings.profile')
    render :settings
  end

  def mail
    add_breadcrumb I18n.t('views.users.settings.mail')
    render :settings
  end

  def password
    add_breadcrumb I18n.t('views.users.settings.password')
    render :settings
  end

  def subscriptions
    add_breadcrumb I18n.t('views.users.settings.subscriptions')
    render :settings
  end

  private

  def check_access
    authorize @user, :show?
  end

  def add_profile_breadcrumbs
    add_breadcrumb I18n.t('my_profile'), @user
  end
end
