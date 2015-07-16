class CreateYandexMarketExports < ActiveRecord::Migration
  def change
    create_table :yandex_market_exports do |t|
      t.string :state
      t.string :file

      t.text :error_messages

      t.timestamps
    end
  end
end
