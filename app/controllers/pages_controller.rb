class PagesController < FrontController
  inherit_resources

  before_filter :not_found_page, except: :feedback

  actions :show, :feedback

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

  def feedback
    if feedback_params[:question].length <= 500
      FeedbackMailer.delay.feedback(feedback_params)
      flash!(:success)
    else
      flash!(:error)
    end

    redirect_to page_path(:help)
  end

  private

  def resource
    Page.find_by(slug: params[:id])
  end

  def not_found_page
    redirect_to [:root], flash: { error: I18n.t('page_not_found') } if resource.nil?
  end

  def feedback_params
    params.require(:feedback).permit(:name, :phone, :email, :question, :subject)
  end
end
