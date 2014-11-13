class PostsController < FrontController
  inherit_resources

  actions :show

  def show
    add_breadcrumb(resource.post_category_title, resource.post_category)
    add_breadcrumb(resource.title, resource)
    show!
  end
end
