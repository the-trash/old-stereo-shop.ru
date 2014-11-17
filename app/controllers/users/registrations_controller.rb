class Users::RegistrationsController < Devise::RegistrationsController
  def new
    add_breadcrumb I18n.t('registration'), [:new, :user, :registration]
    super
  end

  def create
    if simple_captcha_valid?
      super
    else
      redirect_to :back, alert: I18n.t('simple_captcha.message.default')
    end
  end

  private

  def simple_captcha_valid?
    return true if SimpleCaptcha.always_pass
    return @_simple_captcha_result unless @_simple_captcha_result.nil?

    if params[:user] && params[:user][:captcha]
      data = SimpleCaptcha::Utils::simple_captcha_value(params[:user][:captcha_key] || session[:captcha])
      result = data == params[:user][:captcha].delete(" ").upcase
      SimpleCaptcha::Utils::simple_captcha_passed!(session[:captcha]) if result
      @_simple_captcha_result = result
      result
    else
      false
    end
  end
end
