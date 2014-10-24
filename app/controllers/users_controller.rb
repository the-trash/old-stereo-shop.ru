class UsersController < FrontController
  before_action :set_user, only: :show

  # GET /users/:id.:format
  def show
    redirect_to profile_users_path
  end

  # GET /users/profile
  def edit
    authorize current_user
    @user = current_user

    add_breadcrumb 'Мой профиль'
  end

  # POST /users/profile
  def update
    authorize current_user
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to profile_users_path, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def wishlist
    authorize current_user, :update?
    @user   = current_user
    @wishes = Product.where(id: current_user.wishes.map(&:product_id))

    add_breadcrumb 'Мой список желаний'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [ :full_name, :email ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
