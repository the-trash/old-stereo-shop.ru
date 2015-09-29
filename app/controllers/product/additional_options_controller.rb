class Product::AdditionalOptionsController < FrontController
  respond_to :json

  skip_before_action :verify_authenticity_token
  skip_before_filter :set_variables, :store_location

  def show
    @photos = additional_option.photos.published
    @product_attributes = additional_option.product_attributes.published
      .by_option_value_id params[:value].to_i

    respond_with additional_option
  end

  private

  def product
    @product ||= Product.find params[:product_id]
  end

  def additional_option
    @additional_option ||= product.additional_options.published.find params[:id]
  end
end
