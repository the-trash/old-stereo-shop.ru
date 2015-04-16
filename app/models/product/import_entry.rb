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
  ATTR_SHOULD_EXISTS = %i(title brand price stores euro_price)
  ERRORS_SCOPE = [:activerecord, :errors, :models, 'product/import_entry']

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
    if valid? && attributes_exists?
      form = ::Import::ProductForm.new product, self, product.persisted?

      form.save
    else
      error! errors.full_messages
    end
  end

  def save_errors errors_full_messages
    update_column :import_errors, errors_full_messages.join("\r\n") if errors_full_messages.present?
  end

  def product
    existing_product || build_product
  end

  def need_update?
    need_update == 'true'
  end

  def new_product?
    new_product == 'true'
  end

  def permitted_params
    import_main.params.merge!(import_stores.params)
  end

  def import_stores
    ::Import::Store.new(self)
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

  def build_product
    Product.new(permitted_params)
  end

  def import?
    need_update? || new_product?
  end

  def import_main
    ::Import::Main.new(self)
  end

  def attributes_exists?
    exist = true

    ATTR_SHOULD_EXISTS.each do |attr|
      if !self.send(attr).present?
        exist = false
        errors.add attr, I18n.t(attr, scope: ERRORS_SCOPE)
      end
    end

    exist
  end
end
