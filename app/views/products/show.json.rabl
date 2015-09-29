object @product

attributes :id, :title, :average_score, :published_reviews_count, :price_with_discount,
  :description, :price

child @show_presenter.additional_options => :additional_options do
  attributes :id, :title, :render_type

  child values: :options_values do
    attributes :id, :value, :state
  end
end
