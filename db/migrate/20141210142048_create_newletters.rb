class CreateNewletters < ActiveRecord::Migration
  def change
    create_table :newletters do |t|
      t.string :title
      t.text :description

      t.belongs_to :admin_user, index: true
      t.belongs_to :post_category, index: true

      t.datetime :last_delivery

      t.integer :state, default: 1
      t.integer :subscription_type, default: 0

      t.hstore :settings

      t.timestamps
    end

    add_column :users, :subscription_settings, :hstore

    %i(state subscription_type).each do |col|
      add_index :newletters, col
    end
  end
end
