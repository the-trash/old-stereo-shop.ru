class RemoveTrashIndexesFromReviews < ActiveRecord::Migration
  def change
    remove_index :reviews, column: :user_id
    remove_index :reviews, column: [:user_id, :recallable_id, :recallable_type]
    remove_index :reviews, column: [:recallable_id, :recallable_type, :state]
  end
end
