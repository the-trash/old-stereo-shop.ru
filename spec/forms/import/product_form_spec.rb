describe Import::ProductForm do
  subject { described_class.new product, import_entry, persisted }

  context 'when product is new' do
    let(:import_entry) { create :product_import_entry }
    let(:product) { import_entry.product }
    let(:persisted) { false }

    specify { expect(subject.valid?).to be_truthy }
    specify { expect(subject.save).to be_truthy }
    specify { expect{ subject.save }.to change{ Product.count }.from(0).to(1) }
  end

  context 'when product exists' do
    let!(:product) { create :product, :with_stores }
    let(:products_store) { product.products_stores.first }
    let(:stores) { "#{products_store.store.title}:#{products_store.count}" }
    let(:import_entry) {
      create :product_import_entry, title: product.title, stores: stores, need_update: true
    }
    let(:persisted) { true }

    specify { expect(subject.valid?).to be_truthy }
    specify { expect(subject.save).to be_truthy }
    specify { expect{ subject.save }.not_to change{ Product.count } }
    specify { expect{ subject.save }.to change{ product.reload.products_stores.count }.from(3).to(1) }
  end
end
