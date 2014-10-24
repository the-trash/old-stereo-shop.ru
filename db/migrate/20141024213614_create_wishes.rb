class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.references :user
      t.references :product

      t.timestamps
    end
  end
end
