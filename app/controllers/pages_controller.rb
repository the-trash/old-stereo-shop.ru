class PagesController < FrontController
  inherit_resources
  actions :show

  before_filter :not_found_page

  def show
    add_breadcrumb(resource.title, resource)

    if params[:id] == 'help'
      @questions_category = PostCategory.find_by(title: I18n.t('questions'))

      render :help
    else
      show!
    end
  end

  def help
  end

  private

  def resource
    Page.find_by(slug: params[:id])
  end

  def not_found_page
    redirect_to [:root], flash: { error: I18n.t('page_not_found') } if resource.nil?
  end
end
