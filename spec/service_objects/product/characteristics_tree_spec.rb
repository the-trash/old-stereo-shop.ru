describe Product::CharacteristicsTree do
  let(:product) { create :product }

  subject { described_class.new(product).characteristics_tree }

  context 'when product contain characteristics' do
    let(:characteristic_category) { create :characteristic_category }
    let(:characteristic) { create :characteristic, characteristic_category: characteristic_category }
    let!(:characteristics_product) {
      create :characteristics_product,
        characteristic: characteristic,
        product: product
      }

    specify { expect(subject.first[:category]).to eq(characteristic_category) }
    specify {
      expect(subject.first[:characteristics].first[:characteristic]).
        to eq(characteristic)
    }
    specify {
      expect(subject.first[:characteristics].first[:characteristic_value]).
        to eq(characteristics_product)
    }
  end

  specify { expect(subject).to eq([]) }
end
