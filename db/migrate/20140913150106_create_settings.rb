class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value
      t.string :description
      t.string :group

      t.timestamps
    end
  end
end
