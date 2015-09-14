class ProductsController < FrontController
  before_action :check_product_state, except: :index
  before_filter :add_product_to_user_session, only: :show

  inherit_resources

  actions :index, :show

  def index
    add_breadcrumb(I18n.t('search'))

    @brands = brands

    index!
  end

  def show
    @show_presenter = Products::ShowPresenter.new(resource)
    gon.rabl template: 'app/views/products/show.json', as: :product

    if params_with_additional_option_value_exists?
      @additional_option_value =
        resource.additional_options_values.published
          .find(params[:additional_option_value])
      @product_new_values = @additional_option_value.new_values
    end

    breadcrumbs_with_ancestors(@show_presenter.product_category, resource)

    show!
  end

  # TODO remove it and make by REST
  def more_review
    render partial: 'products/includes/review',
      collection: last_reviews.offset(params[:more].to_i),
      as: :review, layout: false
  end

  private

  def add_product_to_user_session
    if current_user && !session[:user]['product_ids'].include?(resource.id)
      session[:user]['product_ids'] << resource.id
    end
  end

  def check_product_state
    redirect_to_root_with_flash unless resource.published?
  rescue ActiveRecord::RecordNotFound
    redirect_to_root_with_flash
  end

  def collection_query_helper
    Products::IndexQuery.new end_of_association_chain, params
  end

  def collection
    get_collection_ivar || set_collection_ivar(collection_query_helper.all)
  end

  def params_with_additional_option_value_exists?
    params[:additional_option_value].present? && params[:additional_option_value].to_i != 0
  end

  def redirect_to_root_with_flash
    redirect_to [:root], flash: { error: I18n.t('controllers.products.product_not_found') }
  end

  def brands
    Brand.where(id: collection.map(&:brand_id).uniq).published
  end
end
