class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.belongs_to :user, index: true
      t.string :session_token, null: false
      t.integer :products_count, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false
    end
  end
end
