class WelcomeController < FrontController
  def index
    @news = Post.for_front('Новости', 3)
    @useful_information = Post.for_front('Полезная информация', 3)
  end
end
