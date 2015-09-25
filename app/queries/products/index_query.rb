class Products::IndexQuery < Struct.new(:collection, :params)
  def initialize collection, params
    super

    by_query_string
      .queried_by_brand
      .sort
  end

  def all
    sorted_collection
      .published
      .by_position
      .with_price_larger_than_value
      .includes(:photos)
      .paginate(page: params[:page], per_page: Settings.pagination.products)
  end

  def by_query_string
    @sorted_collection = by_query_string? ? sorted_collection.by_q(params[:q]) : sorted_collection
    self
  end

  def queried_by_brand
    @sorted_collection = by_brand? ? sorted_collection.by_brand(params[:brand_id]) : sorted_collection
    self
  end

  def sort
    @sorted_collection = need_sort? ? sorted_collection.sort_by(params[:sort_by]) : sorted_collection
    self
  end

  private

  def sorted_collection
    @sorted_collection ||= collection
  end

  def by_query_string?
    params[:q].present?
  end

  def by_brand?
    params[:brand_id].to_i != 0
  end

  def need_sort?
    params[:sort_by].present?
  end
end
