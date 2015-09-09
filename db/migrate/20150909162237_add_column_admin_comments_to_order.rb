class AddColumnAdminCommentsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :admin_comment, :text
  end
end
