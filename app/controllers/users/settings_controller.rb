class Users::SettingsController < UsersController
  before_action :check_access

  def profile
  end

  def mail
  end

  def password
  end

  def subscriptions
  end

  private

  def check_access
    authorize @user
  end
end
