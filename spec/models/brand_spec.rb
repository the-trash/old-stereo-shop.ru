describe Brand do
  let(:brand) { create :brand }

  context 'concerns' do
    %w(friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    it { should belong_to(:admin_user) }
    it { should have_many(:products).dependent(:destroy) }
  end

  context 'validates' do
    %i(title admin_user_id).each do |f|
      it { should validate_presence_of(f) }
    end
  end

  describe '.with_published_products' do
    subject { Brand.with_published_products }

    context 'when brand have published product' do
      let!(:product) { create :product, brand: brand }

      specify { expect(subject).to include(brand) }
    end

    context "when brand haven't got any published products" do
      let!(:product) { create :product, :draft, brand: brand }

      specify { expect(subject).not_to include(brand) }
    end
  end

  describe '.by_product_category' do
    subject { Brand.by_product_category(product_category_id) }

    context 'when product_category_id is nil' do
      let(:product_category_id) { nil }

      specify { expect(subject).to include(brand) }
    end

    context "when brand doesn't have any products with product_category_id" do
      let!(:product) { create :product, brand: brand }
      let(:product_category_id) { 'some product_category_id' }

      specify { expect(subject).to be_empty }
    end

    context 'when brand have products with product_category_id' do
      let!(:product) { create :product, brand: brand }
      let(:product_category_id) { product.product_category_id }

      specify { expect(subject).to include(brand) }
    end
  end
end
