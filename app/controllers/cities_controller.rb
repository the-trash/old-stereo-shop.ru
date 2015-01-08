class CitiesController < FrontController
  skip_before_filter :set_variables

  respond_to :json

  inherit_resources

  actions :index, :show

  private

  def end_of_association_chain
    if params[:query].present?
      super.by_q(params[:query]).limit(Settings.pagination.cities).includes(:region)
    else
      super
    end
  end
end
