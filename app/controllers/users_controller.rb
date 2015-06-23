class UsersController < FrontController
  before_filter :set_user, :authenticate_user!
  skip_before_filter :set_variables, only: :update
  after_action :verify_authorized

  def show
    authorize @user

    add_breadcrumb I18n.t('my_profile')

    @orders = @user.orders.includes(:line_items, cart: :line_items).desc_ordered
      .paginate(page: params[:page], per_page: Settings.pagination.orders)
  end

  def you_watched
    authorize @user, :show?

    add_breadcrumb I18n.t('my_profile'), @user
    add_breadcrumb I18n.t('you_watched')

    @products =
      Product.where(id: session[:user]['product_ids'].uniq.map(&:to_i)).popular.
        paginate(page: params[:page], per_page: Settings.pagination.products)
  end

  def update
    authorize @user

    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, bypass: true)
        format.html { redirect_to :back, flash: :success }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, flash: :error }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [
      :full_name, :email, :full_name, :birthday, :phone, :city_id, :index,
      :address, :email, :unsubscribe
    ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    accessible << Newletter::SUBSCRIPTION_TYPES

    params.require(:user).permit(accessible)
  end
end
