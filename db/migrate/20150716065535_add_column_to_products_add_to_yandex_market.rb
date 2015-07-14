class AddColumnToProductsAddToYandexMarket < ActiveRecord::Migration
  def change
    add_column :products, :add_to_yandex_market, :boolean, default: true
  end
end
