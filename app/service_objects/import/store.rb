class Import::Store < Import::BaseImport
  extend Memoist

  delegate :stores, to: :import_entry

  validate :parse_data, if: :import_entry?

  def params
    {}.tap do |a|
      a[:products_stores_attributes] = {}

      parse_data.each do |store|
        a[:products_stores_attributes].
          merge!(store_params(store[:store].id, store[:count])) if store[:store]
      end if stores.present?
    end
  end

  def store_params(store_id, count, options = {})
    {
      "#{store_id}" => {
        store_id: store_id,
        count: count
      }.reverse_merge!(options)
    }
  end

  private

  def store title
    Store.find_by!(title: title)
  rescue ActiveRecord::RecordNotFound => e
    import_entry.errors.add :stores, errors_message('store', title: title)
    nil
  end

  def parse_data(first_seporator = ';', second_seporator = ':')
    [].tap do |a|
      stores.split(first_seporator).each do |data|
        a << store_hash(data, second_seporator)
      end
    end
  end
  memoize :parse_data

  def store_hash(data, separator)
    splited_data = data.split(separator)

    {
      store: store(splited_data[0]),
      count: splited_data[1]
    }
  end
end
