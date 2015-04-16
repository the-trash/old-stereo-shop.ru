class Import::ProductForm < Struct.new(:product, :import_entry, :persisted?)
  include ActiveModel::Validations

  delegate :need_update?, :permitted_params, :import_stores, to: :import_entry
  delegate :products_stores, to: :product

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    if persisted?
      if need_update?
        update_store_params
        update_product
      end
    else
      save_product
    end
  end

  def save_product
    product.save!
  rescue ActiveRecord::RecordInvalid => e
    errors.add :product, e.message
  end

  def update_product
    product.update_attributes!(updated_params)
  rescue ActiveRecord::RecordInvalid => e
    errors.add :product, e.message
  end

  def updated_params
    permitted_params.merge!({ products_stores_attributes: stores_attributes })
  end

  def update_store_params
    products_stores.each do |relation|
      options =
        if stores_attributes["#{relation.store_id}"].present?
          { id: relation.id }
        else
          { id: relation.id, _destroy: 1 }
        end

      stores_attributes.merge!(updated_store_params(relation, options))
    end
  end

  def stores_attributes
    @stores_attributes ||= permitted_params[:products_stores_attributes]
  end

  def updated_store_params(relation, options = {})
    import_stores.store_params(relation.store_id, relation.count, options)
  end
end
