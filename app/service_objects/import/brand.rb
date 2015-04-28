class Import::Brand < Import::BaseImport
  validate :brand, if: :import_entry?

  def brand
    Brand.find_by!(title: import_entry.brand)
  rescue ActiveRecord::RecordNotFound => e
    import_entry.errors.add :brand, errors_message('brand', title: import_entry.brand)
    nil
  end

  def params
    { brand: brand }
  end
end
