class AddElco < ActiveRecord::Migration
  def change
    create_table :elco_imports do |t|
      t.text   :elco_success
      t.text   :elco_errors
      t.string :state, default: :pending

      t.datetime :finished_at
      t.timestamps
    end

    add_column :products, :elco_id,     :string, default: ''
    add_column :products, :elco_state,  :string, default: ''
    add_column :products, :elco_errors, :text

    add_column :products, :elco_amount_home, :integer
    add_column :products, :elco_amount_msk,  :integer

    add_column :products, :elco_updated_at, :datetime

    add_column :products, :elco_price,   :decimal, precision: 10, scale: 2, default: 0.0, null: false
    add_column :products, :elco_markup,  :decimal, precision: 8,  scale: 2, default: 0.0, null: false
  end
end
