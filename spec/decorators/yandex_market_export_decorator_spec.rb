describe YandexMarketExportDecorator do
  let(:product) { create :product }
  let(:decorated_product) { described_class.decorate product }

  subject { decorated_product.text_format_temp_body }

  specify { expect(subject.size).to eq Settings.yandex_market.text_format.headers.size }

  describe '#filtered_description' do
    subject { decorated_product.send :filtered_description }

    specify { expect(subject.length).to eq Settings.yandex_market.text_format.letters_count }
  end
end
