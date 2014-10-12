class WelcomeController < FrontController
  def index
    @product_categories = ProductCategory.for_front.arrange(order: :position)
    @sale = ProductCategory.sale.arrange(order: :position)
  end
end
