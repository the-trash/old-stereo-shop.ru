class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :votable, polymorphic: true
      t.belongs_to :user
      t.integer :score, null: false

      t.timestamps
    end

    add_index :ratings, [:votable_id, :votable_type]
    add_index :ratings, [:votable_id, :votable_type, :score]
    add_index :ratings, [:votable_id, :votable_type, :user_id]
    add_index :ratings, :user_id
  end
end
