describe Product::StoresTree do
  let(:product) { create :product }

  subject { described_class.new(product).stores_tree }

  specify { expect(subject).to eq([]) }

  context 'when product contain stores' do
    let(:store) { create :store }
    let!(:products_store) { create :products_store, product: product, store: store }

    specify { expect(subject.first[:store]).to eq(store) }
    specify { expect(subject.first[:store_count]).to eq(products_store) }
  end
end
