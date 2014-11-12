class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug

      t.text :short_text
      t.text :full_text

      t.integer :state, default: 1

      t.hstore :meta

      t.belongs_to :admin_user

      t.timestamps
    end

    add_index :pages, :admin_user_id
    add_index :pages, :state
    add_index :pages, :slug
  end
end
