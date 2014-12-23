class CitiesController < FrontController
  skip_before_filter :set_variables

  def get_cities
    gon.selector_search_limit = Settings.pagination.cities
    @cities = City.by_q(params[:q])
  end
end
