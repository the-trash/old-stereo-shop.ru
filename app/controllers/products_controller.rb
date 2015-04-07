class ProductsController < FrontController
  before_action :check_product_state, except: :index

  inherit_resources

  actions :index, :show

  def index
    add_breadcrumb(I18n.t('search'))

    @brands = Brand.where(id: collection.map(&:brand_id)).published

    index!
  end

  def show
    session[:user]['product_ids'] << resource.id if current_user

    @product_category   = resource.product_category
    @stores             = Product::StoresTree.new(resource).stores_tree
    @characteristics    = Product::CharacteristicsTree.new(resource).characteristics_tree
    @related_products   = resource.related_products.published
    @similar_products   = resource.similar_products.published
    @last_reviews       = last_reviews
    @additional_options = resource.additional_options.published.includes(:values)

    if params_with_additional_option_value_exists?
      @additional_option_value =
        resource.additional_options_values.published
          .find(params[:additional_option_value])
      @product_new_values = @additional_option_value.new_values
    end

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
    if current_user && !current_user.wishes.pluck(:product_id).include?(resource.id)
      current_user.wishes << Wish.new(product: resource)
    end
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
    params.require(:review).permit \
      :pluses, :cons, :body, :user_id
  end

  def last_reviews
    resource.reviews.published.related.includes(:rating, :user)
  end

  def check_product_state
    redirect_to [:root], flash: { error: I18n.t('controllers.products.product_not_found') } unless resource.published?
  end

  def end_of_association_chain
    end_collection_chain = super

    end_collection_chain = end_collection_chain.by_q(params[:q]) if params[:q].present?
    end_collection_chain = end_collection_chain.by_brand(params[:brand_id]) if params[:brand_id].to_i != 0
    end_collection_chain = end_collection_chain.sort_by(params[:sort_by]) if params[:sort_by].present?

    # TODO products/index with search - add includes characteristics_products: :characteristic
    end_collection_chain.published.includes(:photos)
  end

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain
      .paginate(page: params[:page], per_page: Settings.pagination.products))
  end

  def params_with_additional_option_value_exists?
    params[:additional_option_value].present? && params[:additional_option_value].to_i != 0
  end
end
