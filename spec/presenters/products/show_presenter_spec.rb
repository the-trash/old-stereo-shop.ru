describe Products::ShowPresenter do
  let(:user) { create :user }
  let(:product) { create :product }

  subject { described_class.new(product) }

  describe '#last_reviews' do
    let!(:review) { create :review, :published, recallable: product, user: user }
    let!(:another_review) { create :review, user: user }

    specify { expect(subject.last_reviews).to include(review) }
    specify { expect(subject.last_reviews).not_to include(another_review) }
  end

  describe '#related_products' do
    let!(:related_product) { create :product, :with_related, product: product }
    let!(:product2) { create :product }

    specify { expect(subject.related_products).to include(related_product) }
    specify { expect(subject.related_products).not_to include(product2) }
  end

  describe '#similar_products' do
    let!(:similar_product) { create :product, :with_similar, product: product }
    let!(:product2) { create :product }

    specify { expect(subject.similar_products).to include(similar_product) }
    specify { expect(subject.similar_products).not_to include(product2) }
  end

  describe '#additional_options' do
    let!(:additional_option) { create :additional_option, product: product }
    let!(:additional_option2) { create :additional_option }

    specify { expect(subject.additional_options).to include(additional_option) }
    specify { expect(subject.additional_options).not_to include(additional_option2) }
  end

  describe '#stores' do
    let(:stores) { Product::StoresTree.new(product).stores_tree }

    specify { expect(subject.stores).to eq(stores) }
  end

  describe '#characteristics' do
    let(:characteristics) { Product::CharacteristicsTree.new(product).characteristics_tree }

    specify { expect(subject.characteristics).to eq(characteristics) }
  end

  specify { expect(subject.product_category).to eq(product.product_category) }
end
