class YandexMarketExportWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5, unique: true, queue: :critical

  def perform yandex_market_export_id
    yandex_market_export = YandexMarketExport.find yandex_market_export_id
    service_obj          = YandexMarketCsv.new

    yandex_market_export.file = service_obj.to_csv

    if yandex_market_export.save
      yandex_market_export.complete
    else
      yandex_market_export.update_column :error_messages, yandex_market_export.errors.full_messages.join("\r\n")
    end

    service_obj.unlink
  end
end
