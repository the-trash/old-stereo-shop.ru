class Products::ShowPresenter < Struct.new(:product)
  delegate :reviews, :product_category, to: :product

  def last_reviews
    reviews.published.related.includes(:rating, :user)
  end

  def stores
    Product::StoresTree.new(product).stores_tree
  end

  def characteristics
    Product::CharacteristicsTree.new(product).characteristics_tree
  end

  def related_products
    product.related_products.published
  end

  def similar_products
    product.similar_products.published
  end

  def additional_options
    product.additional_options.published.includes(:values)
  end
end
