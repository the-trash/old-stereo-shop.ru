class PostCategoriesController < FrontController
  inherit_resources

  actions :show

  def show
    # add_breadcrumb(I18n.t('news'), [:post_categories])
    add_breadcrumb(resource.title, resource)

    @posts = resource.posts.published.paginate(page: params[:page], per_page: Settings.pagination.posts)
    show!
  end
end
