class ProductsController < FrontController
  inherit_resources

  actions :index, :show

  def show
    @product_category = resource.product_category
    @stores           = resource.make_stores
    @characteristics  = resource.make_characteristics_tree
    @related_products = resource.related_products
    @similar_products = resource.similar_products

    breadcrumbs_with_ancestors(@product_category, resource)

    show!
  end

  def add_review
    if resource.can_vote?(current_user.id)
      ActiveRecord::Base.transaction do
        vote = resource.generate_vote(current_user, params[:review][:rating_score].to_i)
        resource.reviews.create!(permit_review.merge!(rating_id: vote.id))
      end

      redirect_to :back, notice: 'Спасибо за Ваш голос'
    else
      redirect_to :back, alert: 'Вы уже голосовали'
    end
  end

  def add_to_wishlist
    if current_user.present?
      current_user.wishes << Wish.new(product: resource)
    end
  end

  private

  def permit_review
    params.require(:review).permit(
      :pluses, :cons, :body, :user_id
    )
  end
end
