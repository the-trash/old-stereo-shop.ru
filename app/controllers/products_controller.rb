class ProductsController < FrontController
  before_filter :check_product_state

  inherit_resources

  actions :index, :show

  def show
    session[:user]['product_ids'] << resource.id if current_user

    @product_category = resource.product_category
    @stores           = resource.make_stores
    @characteristics  = resource.make_characteristics_tree
    @related_products = resource.related_products.published
    @similar_products = resource.similar_products.published
    @last_reviews     = last_reviews

    breadcrumbs_with_ancestors(@product_category, resource)

    show!
  end

  def add_review
    if resource.can_vote?(current_user.id)
      ActiveRecord::Base.transaction do
        vote = resource.generate_vote(current_user, params[:review][:rating_score].to_i)
        resource.reviews.create!(permit_review.merge!(rating_id: vote.id))
      end

      redirect_to :back, flash: :success
    else
      redirect_to :back, flash: :error
    end
  end

  def new_review
    render partial: 'products/includes/new_review', layout: false
  end

  def add_to_wishlist
    current_user.wishes << Wish.new(product: resource) if current_user
  end

  def remove_from_wishlist
    current_user.wishes.find_by(product: resource).destroy if current_user
    redirect_to :back, flash: :success
  end

  def more_review
    render partial: 'products/includes/review',
      collection: last_reviews.offset(params[:more].to_i),
      as: :review, layout: false
  end

  private

  def permit_review
    params.require(:review).permit(
      :pluses, :cons, :body, :user_id
    )
  end

  def last_reviews
    resource.reviews.includes(:rating, :user).published.related
  end

  def check_product_state
    redirect_to [:root], flash: { error: I18n.t('controllers.products.product_not_found') } unless resource.published?
  end
end
