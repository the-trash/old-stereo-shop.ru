describe YandexMarketExport, type: :model do
  let(:yandex_market_export) { build :yandex_market_export }

  describe '#save' do
    subject { yandex_market_export.save }

    specify {
      expect(yandex_market_export).to receive(:start_export_job)
      subject
    }
  end
end
