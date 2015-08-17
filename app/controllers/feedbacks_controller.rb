class FeedbacksController < FrontController
  respond_to :json, only: :call_me
  skip_before_filter :set_variables, except: [:feedback]

  def create
    if feedback_params[:question].length <= 500
      FeedbackMailer.delay.feedback(feedback_params)
      flash!(:success)
    else
      flash!(:error)
    end

    redirect_to page_path(:help)
  end

  def call_me
    FeedbackMailer.delay.call_me call_me_params
    render nothing: true
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :phone, :email, :question, :subject)
  end

  def call_me_params
    params.require(:feedback).permit(:phone)
  end
end
