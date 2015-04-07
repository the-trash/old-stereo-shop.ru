class Product::StoresTree < Struct.new(:product)
  delegate :products_stores, :stores, to: :product

  def stores_tree
    @stores_tree ||= [].tap do |a|
      published_stores.each do |store|
        a << {
          store: store,
          store_count: product_stores[store.id]
        }
      end
    end
  end

  private

  def product_stores
    @product_stores ||= products_stores.index_by(&:store_id)
  end

  def published_stores
    @published_stores ||= stores.where(id: product_stores.keys).published.order_by
  end
end
