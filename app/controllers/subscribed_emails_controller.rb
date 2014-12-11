class SubscribedEmailsController < FrontController
  skip_before_filter :set_variables, only: :create
  inherit_resources

  actions :create, :destroy

  def create
    subscribed_email =
      if current_user
        current_user.build_subscribed_email(permitted_params)
      else
        SubscribedEmail.new(permitted_params)
      end

    flash_key =
      if subscribed_email.save
        current_user.update(unsubscribe: false)
        :success
      else
        :error
      end

    redirect_to [:root], flash: flash_key
  end

  private

  def permitted_params
    params.require(:subscribed_email).permit(:email)
  end
end
