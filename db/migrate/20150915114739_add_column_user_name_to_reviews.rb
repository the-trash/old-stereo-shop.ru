class AddColumnUserNameToReviews < ActiveRecord::Migration
  def up
    add_column :reviews, :user_name, :string

    say_with_time "Updating user's name for each review" do
      Review.find_each do |review|
        decorated_review = ReviewDecorator.decorate review
        review.update_column :user_name, decorated_review.correct_user_name
      end
    end
  end

  def down
    remove_column :reviews, :user_name
  end
end
