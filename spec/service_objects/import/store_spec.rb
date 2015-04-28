describe Import::Store do
  let(:store1) { create :store }
  let(:store2) { create :store }
  let(:import_entry) { create :product_import_entry, stores: "#{store1.title}:1;#{store2.title}:2" }
  let(:errors_for_stores) { import_entry.errors.messages[:stores] }
  let(:specified_params) {
    {
      products_stores_attributes: {
        "#{store1.id}" => {
          store_id: store1.id,
          count: '1'
        },
        "#{store2.id}" => {
          store_id: store2.id,
          count: '2'
        }
      }
    }
  }

  subject { described_class.new import_entry }

  specify { expect(subject.params).to eq(specified_params) }

  context "when store doesn't exist" do
    let(:import_entry) { create :product_import_entry, stores: 'Store:123' }
    let(:errors_message) { I18n.t \
      'store',
      scope: Product::ImportEntry::ERRORS_SCOPE,
      title: 'Store'
    }

    before { subject.valid? }

    specify { expect(errors_for_stores).to include(errors_message) }
  end

  describe '#store_params' do
    let(:store_params) { [store1.id, '1', { _destroy: '1' }] }
    let(:specified_store_params) {
      {
        "#{store1.id}" => {
          store_id: store1.id,
          count: '1',
          :_destroy => '1'
        }
      }
    }

    subject { described_class.new(import_entry).store_params(*store_params) }

    specify { expect(subject).to eq(specified_store_params) }
  end
end
