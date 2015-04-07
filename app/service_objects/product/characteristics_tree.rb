class Product::CharacteristicsTree < Struct.new(:product)
  def characteristics_products
    @characteristics_products ||=
      product.characteristics_products.index_by(&:characteristic_id)
  end

  def characteristics
    @characteristics ||= product.characteristics.group_by(&:characteristic_category_id)
  end

  def characteristic_categories
    @characteristic_categories ||=
      CharacteristicCategory.where(id: characteristics.keys).order(id: :asc)
  end

  def characteristics_tree
    @characteristics_tree ||= [].tap do |a|
      characteristic_categories.each do |category|
        tmp = {
            category: category,
            characteristics: []
          }

        characteristics[category.id].each do |char|
          tmp[:characteristics] <<
            {
              characteristic: char,
              characteristic_value: characteristics_products[char.id]
            }
        end

        a << tmp
      end
    end
  end
end
