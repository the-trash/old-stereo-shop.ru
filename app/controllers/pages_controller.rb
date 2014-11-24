class PagesController < FrontController
  inherit_resources

  before_filter :not_found_page

  actions :show

  def show
    add_breadcrumb(resource.title, resource)
    show!
  end

  private

  def resource
    Page.find_by(slug: params[:id])
  end

  def not_found_page
    redirect_to [:root], flash: { error: I18n.t('page_not_found') } if resource.nil?
  end
end
