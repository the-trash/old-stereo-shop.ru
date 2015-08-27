class CreateSeoSettings < ActiveRecord::Migration
  def change
    create_table :seo_settings do |t|
      t.string :controller_name
      t.string :action_name
      t.hstore :meta, default: {}, null: false
      t.timestamps
    end
    
    add_index :seo_settings, [:controller_name, :action_name]
  end
end
