describe YandexMarketExportWorker do
  let!(:product) { create :product }
  let!(:yandex_market_export) { create :yandex_market_export, :without_file }

  subject { described_class.new.perform yandex_market_export.id }

  specify { expect{ subject }.to change{ yandex_market_export.reload.state }.to('completed') }
  specify { expect{ subject }.to change{ yandex_market_export.reload.file.url }.from(nil) }
end
