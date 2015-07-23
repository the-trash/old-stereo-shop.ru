class PostCategoriesController < FrontController
  inherit_resources

  actions :show

  def show
    # add_breadcrumb(I18n.t('news'), [:post_categories])
    add_breadcrumb(resource.title, resource)

    @posts = resource.with_posts.paginate(page: params[:page], per_page: Settings.pagination.posts)
    show!
  end
end
