class Users::SessionsController < Devise::SessionsController
  def new
    add_breadcrumb I18n.t('authentication'), [:new, :user, :session]
    super
  end
end
