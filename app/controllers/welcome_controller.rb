class WelcomeController < FrontController
  def index
    @product_categories = ProductCategory.for_front.arrange(order: :position)
    @news = Post.for_front('Новости')
    @useful_information = Post.for_front('Полезная информация')
  end
end
