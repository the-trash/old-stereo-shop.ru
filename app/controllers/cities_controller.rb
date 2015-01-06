class CitiesController < FrontController
  skip_before_filter :set_variables

  def get_cities
    @cities = City.by_q(params[:query]).limit(Settings.pagination.cities).includes(:region)
  end
end
