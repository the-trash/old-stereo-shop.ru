class Product::CharacteristicsTree < Struct.new(:product)
  delegate :characteristics_products, :characteristics, to: :product

  def characteristics_tree
    @characteristics_tree ||= [].tap do |a|
      characteristic_categories.each do |category|
        tmp = {
            category: category,
            characteristics: []
          }

          group_characteristics[category.id].each do |char|
          tmp[:characteristics] <<
            {
              characteristic: char,
              characteristic_value: char_products[char.id]
            }
        end

        a << tmp
      end
    end
  end

  private

  def char_products
    @char_products ||= characteristics_products.index_by(&:characteristic_id)
  end

  def group_characteristics
    @group_characteristics ||= characteristics.group_by(&:characteristic_category_id)
  end

  def characteristic_categories
    @characteristic_categories ||=
      CharacteristicCategory.where(id: group_characteristics.keys).order(id: :asc)
  end
end
