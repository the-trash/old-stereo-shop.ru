class Users::RegistrationsController < Devise::RegistrationsController
  include SimpleCaptcha::ControllerHelpers

  def new
    add_breadcrumb I18n.t('registration'), [:new, :user, :registration]
    super
  end

  # TODO use here ajax
  def create
    if simple_captcha_valid?
      build_resource(sign_up_params)

      resource_saved = resource.save
      yield resource if block_given?

      if resource_saved
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        assign_cart_to_user

        respond_with resource, location: after_sign_up_path_for(resource)
      else
        clean_up_passwords resource

        # respond_with resource
        redirect_to :back, flash: {
          error: resource.errors.full_messages.join(", ")
        }
      end
    else
      redirect_to :back, flash: {
        error: I18n.t('simple_captcha.message.default')
      }
    end
  end

  private

  def assign_cart_to_user
    @cart.update_column :user_id, resource.id
  end
end
