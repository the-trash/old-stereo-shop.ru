# == Schema Information
#
# Table name: product_imports
#
#  id                             :integer          not null, primary key
#  admin_user_id                  :integer
#  file                           :string(255)
#  state                          :string(255)
#  import_entries_count           :integer
#  completed_import_entries_count :integer
#  failed_import_entries_count    :integer
#  created_at                     :datetime
#  updated_at                     :datetime
#
# Indexes
#
#  index_product_imports_on_admin_user_id  (admin_user_id)
#  index_product_imports_on_state          (state)
#

class Product::Import < ActiveRecord::Base
  IMPORT_STATES = %i(created started cmpleted)

  has_many :import_entries, dependent: :destroy, class_name: 'Product::ImportEntry'
  alias :product_import_entries :import_entries

  belongs_to :admin_user

  validates :file, presence: true

  after_commit :start!, on: :create, if: :created?

  state_machine :state, initial: :created do
    IMPORT_STATES.each { |st| state st }

    event :start do
      transition created: :started
    end

    event :complete do
      transition started: :completed
    end

    after_transition created: :started do |import, transition|
      import.create_entries!
      import.start_import_job
    end
  end

  def has_failed_entries?
    import_entries.with_state(:failed).any?
  end

  mount_uploader :file, CsvFileUploader do
    def store_dir
      "uploads/imports/#{ Rails.env }"
    end
  end

  def create_entries!
    CsvUtf.foreach(file.path, headers: true, header_converters: :symbol).each do |row|
      import_entries.create!(data: row.to_hash)
    end
  end

  def start_import_job
    ProductImportWorker.perform_async id
  end

  def import!
    import_entries.each(&:complete!)
  end
end
