class Users::SettingsController < UsersController
  before_action :check_access
  before_filter :add_profile_breadcrumbs

  def profile
    add_breadcrumb I18n.t('views.users.settings.profile')
  end

  def mail
    add_breadcrumb I18n.t('views.users.settings.mail')
  end

  def password
    add_breadcrumb I18n.t('views.users.settings.password')
  end

  def subscriptions
    add_breadcrumb I18n.t('views.users.settings.subscriptions')
  end

  def settings_update
    if @user.update_attributes(profile_permit)
      flash!(:success)
    else
      flash!(:error)
    end

    redirect_to :back
  end

  private

  def check_access
    authorize @user, :show?
  end

  def add_profile_breadcrumbs
    add_breadcrumb I18n.t('my_profile'), @user
  end

  def profile_permit
    params.require(:user).permit(:full_name, :birthday, :phone, :city, :index, :address, :email)
  end
end
