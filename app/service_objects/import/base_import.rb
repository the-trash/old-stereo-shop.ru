class Import::BaseImport < Struct.new(:import_entry)
  include ActiveModel::Validations

  def errors_message(key, params = {})
    params.reverse_merge!(scope: Product::ImportEntry::ERRORS_SCOPE)

    I18n.t(key, params)
  end

  def import_entry?
    import_entry.present?
  end
end
