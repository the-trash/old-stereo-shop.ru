class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :basic_authentication

  private

  def basic_authentication
    authenticate_or_request_with_http_basic do |name, password|
      name == 'stereo-shop' && password == 'staging'
    end if Rails.env.staging?
  end
end
