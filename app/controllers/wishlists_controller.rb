class WishlistsController < FrontController
  before_filter :set_user, only: :index

  respond_to :html, only: :index
  respond_to :json, except: :index

  inherit_resources
  defaults collection_name: :wishes
  belongs_to :product
  actions :create, :destroy

  def index
    authorize @user, :index?

    add_breadcrumb I18n.t('my_wishlist')

    @wishes = (@user || current_user).wishes.products.
      paginate(page: params[:page], per_page: Settings.pagination.products)
  end

  def create
    authorize current_user, :create?

    create! do |success, failure|
      failure.json { render json: { errors: resource.errors }, status: :unprocessable_entity }
    end
  end

  def destroy
    authorize current_user, :destroy?

    destroy! do |success, failure|
      failure.json { render json: { errors: resource.errors }, status: :unprocessable_entity }
    end
  end

  private

  def build_resource
    @wishlist ||= parent.wishes.build user: current_user
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
