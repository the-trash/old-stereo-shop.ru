class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.date :birthday
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.string :middle_name

      t.timestamps
    end
  end
end
