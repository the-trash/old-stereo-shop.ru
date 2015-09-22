module AdminApp
  class BaseController < ActionController::Base
    layout 'admin_app/admin'
    before_filter :authenticate_admin_user!
    # TODO add Admin::Pundit
    include Pundit
    protect_from_forgery with: :exception
  end
end
