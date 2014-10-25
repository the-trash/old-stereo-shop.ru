class AddNeededColumnsForReviewsAndAdminUsers < ActiveRecord::Migration
  def change
    %i(full_name first_name last_name).each do |column|
      add_column :admin_users, column, :string
    end

    %i(created_at updated_at).each do |column|
      add_column :reviews, column, :datetime
    end
  end
end
