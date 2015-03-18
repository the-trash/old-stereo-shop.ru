# == Schema Information
#
# Table name: product_import_entries
#
#  id            :integer          not null, primary key
#  import_id     :integer
#  state         :string(255)
#  import_errors :text
#  data          :hstore
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_product_import_entries_on_import_id            (import_id)
#  index_product_import_entries_on_import_id_and_state  (import_id,state)
#  index_product_import_entries_on_state                (state)
#

class Product::ImportEntry < ActiveRecord::Base
  extend Memoist

  belongs_to :import, counter_cache: true, class_name: 'Product::Import'

  validates :import, presence: true

  hstore_accessor :data,
    need_update: :string,
    new_product: :string,
    title: :string,
    sku: :string,
    description: :string,
    stores: :string,
    meta: :string,
    brand: :string,
    price: :string,
    discount: :string,
    euro_price: :string

  state_machine :state, initial: :created do
    %i(created completed failed).each { |st| state st }

    event :complete do
      transition created: :completed
    end

    event :error do
      transition any => :failed
    end

    after_transition created: :completed, do: :complete_entry
    before_transition any => :failed, do: :fail_entry
  end

  def import!
    prepare_methods

    if errors.any?
      error! errors.full_messages
    else
      transaction do
        stores_hash.any? ? set_products_count_in_stores : product
        update_product if need_update?
      end
    end
  end

  def save_errors errors_full_messages
    update_column :import_errors, errors_full_messages.join("\r\n")
  end

  def errors_message(key)
    I18n.t(key, scope: [:activerecord, :errors, :models, self.class.name.underscore])
  end

  def product
    existing_product || create_product
  end
  memoize :product

  def product_category
    existing_product_category || create_product_category
  end

  def meta_hash
    split_information(meta)
  rescue
    {
      keywords: nil,
      seo_title: nil,
      seo_description: nil
    }
  end

  def stores_hash
    if stores.presence
      split_information(stores)
    else
      errors.add :stores, errors_message('stores')
    end
  end
  memoize :stores_hash

  def brand_by_title
    Brand.find_by!(title: brand)
  rescue ActiveRecord::RecordNotFound => e
    errors.add :brand, errors_message('brand')
  end
  memoize :brand_by_title

  def split_information(data_information, first_seporator = ';', second_seporator = ':')
    {}.tap do |a|
      data_information.split(first_seporator).each do |one_data_info|
        splited_data_info = one_data_info.split(second_seporator)
        a[splited_data_info[0]] = splited_data_info[1].gsub('|', ', ') if splited_data_info[1].presence
      end
    end
  end

  def store(store_title)
    Store.find_by!(title: store_title)
  rescue ActiveRecord::RecordNotFound => e
    errors.add :store, errors_message('store')
  end
  memoize :store

  def need_update?
    need_update == 'true'
  end

  def new_product?
    new_product == 'true'
  end

  def prepare_methods
    brand_by_title

    check_all_stores if stores_hash
  end

  def check_all_stores
    stores_hash.each do |one_store|
      store(one_store[0])
    end
  end

  private

  def complete_entry
    import! if import?

    import.increment! :completed_import_entries_count if completed?
  end

  def fail_entry transition
    save_errors transition.args.first
    import.increment! :failed_import_entries_count
  end

  def existing_product
    Product.find_by(title: title)
  end

  def create_product
    Product.create!(main_product_information)
  rescue ActiveRecord::RecordInvalid => e
    errors.add :product, e.message
  end

  def existing_product_category
    ProductCategory.find_by(title: I18n.t('product_category_for_import'))
  end

  def create_product_category
    ProductCategory.create!(title: I18n.t('product_category_for_import'))
  rescue ActiveRecord::RecordInvalid => e
    errors.add :product_category, e.message
  end

  def import?
    need_update? || new_product?
  end

  def set_products_count_in_stores
    need_update? && product.products_store_ids.any? ? update_products_count_in_stores : create_products_stores
  end

  def create_products_stores
    stores_hash.each do |one_store|
      begin
        product.products_stores.create! \
          store: store(one_store[0]),
          count: one_store[1]
      rescue ActiveRecord::RecordInvalid => e
        errors.add :products_stores, e.message

      end
    end
  end

  def store_ids_with_titles
    {}.tap do |a|
      stores_hash.each do |one_store|
        store_by_title       = store(one_store[0])
        a[store_by_title.id] = {
          title: store_by_title.title,
          count: one_store[1]
        }
      end
    end
  end
  memoize :store_ids_with_titles

  def products_stores_hash_for_update(store_ids_for_update)
    {}.tap do |a|
      product.products_stores.by_store_ids(store_ids_for_update).each do |products_store|
        a[products_store.id] = {
          store_id: products_store.store_id,
          count: store_ids_with_titles[products_store.store_id][:count]
        }
      end
    end
  end

  def update_products_count_in_stores
    store_ids      = store_ids_with_titles.keys
    ids_for_delete = product.products_stores.pluck(:store_id) - store_ids

    transaction do
      product.products_stores.by_store_ids(ids_for_delete).delete_all if ids_for_delete.any?

      if store_ids.any?
        for_update = products_stores_hash_for_update(store_ids)
        product.products_stores.update(for_update.keys, for_update.values)
      end
    end
  end

  def update_product
    product.update_attributes(main_product_information)
  end

  def main_product_information
    {
      title: title,
      description: description,
      product_category: product_category,
      sku: sku,
      price: price,
      discount: discount,
      euro_price: euro_price,
      brand_id: brand_by_title.id,
      meta: meta_hash
    }
  end
  memoize :main_product_information
end
