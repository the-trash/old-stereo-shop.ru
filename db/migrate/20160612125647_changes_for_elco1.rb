class ChangesForElco1 < ActiveRecord::Migration
  def change
    add_column :elco_imports, :items_to_process, :integer, default: 0
    add_column :elco_imports, :items_processed,  :integer, default: 0
  end
end
