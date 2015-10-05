class AddColumnShortDescToProducts < ActiveRecord::Migration
  include ActionView::Helpers::TextHelper

  def up
    add_column :products, :short_desc, :text

    say_with_time "Copying product's description into short description" do
      Product.find_each do |product|
        short_desc = Sanitize.fragment truncate(product.description, length: 500)
        product.update_column :short_desc, short_desc
      end
    end
  end

  def down
    remove_column :products, :short_desc
  end
end
