class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :user, index: true
      t.belongs_to :rating, index: true
      t.text :body
      t.string :pluses
      t.string :cons
      t.references :recallable, polymorphic: true
      t.integer :state, default: 1
    end

    add_index :reviews, [:recallable_id, :recallable_type]
    add_index :reviews, [:user_id, :recallable_id, :recallable_type], unique: true
    add_index :reviews, [:recallable_id, :recallable_type, :state]

    add_column :users, :reviews_count, :integer, default: 0
    add_column :products, :reviews_count, :integer, default: 0
  end
end
