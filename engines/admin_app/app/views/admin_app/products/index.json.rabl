collection AdminApp::Products::IndexDecorator.decorate_collection(@products)

attributes :id, :title, :price, :discount, :price_with_discount, :product_category_id,
  :thumbnail_url, :sanitized_desc, :translated_state, :product_category_title
