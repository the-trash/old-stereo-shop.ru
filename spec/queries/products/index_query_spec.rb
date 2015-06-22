describe Products::IndexQuery do
  let!(:brand) { create :brand }
  let!(:product_with_zero_price) { create :product, :with_zero_price, brand: brand }
  let!(:published_product) { create :product, brand: brand, title: 'published product' }
  let!(:draft) { create :product, :draft, title: 'drat product' }

  subject { described_class.new(Product, params).all }

  shared_examples_for 'result should contain correct result' do
    specify { expect(subject).to include(published_product) }
    specify { expect(subject).not_to include(draft) }
    specify { expect(subject).not_to include(product_with_zero_price) }
  end

  shared_examples_for 'result should not contain draft products' do
    specify { expect(subject).not_to include(draft) }
    specify { expect(subject).to be_empty }
  end

  context 'when params contain q' do
    let(:params) { { q: published_product.title } }

    it_behaves_like 'result should contain correct result'

    context "when doesn't exist published product" do
      let(:params) { { q: draft.title } }

      it_behaves_like 'result should not contain draft products'
    end
  end

  context 'when params contain brand_id' do
    let(:params) { { brand_id: brand.id } }

    it_behaves_like 'result should contain correct result'

    context "when doesn't exist published products by brand_id" do
      let(:params) { { brand_id: draft.brand_id } }

      it_behaves_like 'result should not contain draft products'
    end
  end

  context 'when params contain sort_by' do
    let(:params) { { sort_by: 'popular' } }

    it_behaves_like 'result should contain correct result'

    context "when params doesn't contain sort_by" do
      let(:params) { { sort_by: nil } }

      it_behaves_like 'result should contain correct result'
    end
  end

  context "when params doesn't contain needed params" do
    let(:params) { {} }

    it_behaves_like 'result should contain correct result'
  end

  context 'when params contain all needed params' do
    let(:params) {
      {
        q: published_product.title,
        brand_id: brand.id,
        sort_by: 'popular'
      }
    }

    it_behaves_like 'result should contain correct result'
  end
end
