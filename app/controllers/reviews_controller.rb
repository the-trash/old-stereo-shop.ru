class ReviewsController < FrontController
  respond_to :json, only: :create
  skip_before_filter :set_variables, :store_location

  def create
    form = ReviewForm.new ReviewDecorator.decorate(build_resource), permitted_params
    form.save

    respond_with form
  end

  private

  def build_resource
    @review ||= Review.new user: current_user
  end

  def permitted_params
    params.require(:review).permit *ReviewForm.permitted_params
  end
end
