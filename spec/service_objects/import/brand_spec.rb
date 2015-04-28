describe Import::Brand do
  let(:brand) { create :brand }
  let(:brand_struct) { described_class.new import_entry }
  let(:import_entry) { create :product_import_entry, brand: brand.title }

  describe '#brand' do
    subject { brand_struct.brand }

    specify { expect(subject).to eq(brand) }

    context "when brand doesn't exist" do
      let(:import_entry) { create :product_import_entry, brand: '' }
      let(:errors_message) { I18n.t \
        'brand',
        scope: Product::ImportEntry::ERRORS_SCOPE,
        title: ''
      }
      let(:errors_for_brand) { import_entry.errors.messages[:brand] }

      specify { expect(subject).to be_nil }

      it 'should add error into main errors array' do
        subject
        expect(errors_for_brand).to include(errors_message)
      end
    end
  end

  context '#params' do
    let(:params) { { brand: brand } }

    subject { brand_struct.params }

    specify { expect(subject).to eq(params) }

    context "when brand doesn't exist" do
      let(:import_entry) { create :product_import_entry, brand: '' }
      let(:params) { { brand: nil } }

      specify { expect(subject).to eq(params) }
    end
  end
end
