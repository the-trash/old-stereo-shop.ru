class RemoveTrashIndexesFromRatings < ActiveRecord::Migration
  def change
    remove_index :ratings, column: :user_id
    remove_index :ratings, column: [:votable_id, :votable_type, :user_id]
    remove_index :ratings, column: [:votable_id, :votable_type, :score]
  end
end
