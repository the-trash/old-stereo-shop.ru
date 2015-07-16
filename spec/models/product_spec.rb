describe Product do
  context 'concerns' do
    %w(photoable ratable friendable statable).each do |concern|
      it_behaves_like(concern)
    end
  end

  context 'relations' do
    %i(admin_user product_category brand).each do |m|
      it { should belong_to(m) }
    end

    {
      :"characteristics" => :characteristics_products,
      :"stores" => :products_stores
    }.each do |k, v|
      it { should have_many(v).dependent(:destroy) }
      it { should have_many(k).through(v) }
    end

    it { should have_many(:reviews).dependent(:destroy) }
  end

  context 'validates' do
    %i(title description product_category_id brand_id).each do |f|
      it { should validate_presence_of(f) }
    end

    %i(products_stores characteristics_products).each do |r|
      it { should accept_nested_attributes_for(r).allow_destroy(true) }
    end
  end

  it { should delegate(:title).to(:product_category).with_prefix }

  describe 'instance methods' do
    let!(:product) { create(:product) }

    describe '#price_with_discount' do
      let(:price_with_discount) { product.price - (product.price * product.discount) / 100 }

      subject { product.price_with_discount }

      context 'product has discount' do
        subject { product.price_with_discount }

        specify {
          expect(subject).to eq(price_with_discount)
        }
      end

      context "when product hasn't discount" do
        let(:product) { create :product, :without_discount }

        specify {
          expect(subject).to eq(price_with_discount)
        }
      end
    end
  end

  describe '#save' do
    let(:product) { build :product, state }

    subject { product.save }

    describe '#generate_sku' do
      context "when sku doesn't exist" do
        let(:state) { :without_sku }

        specify {
          subject
          expect(product.sku).to be_truthy
        }

        specify {
          expect(product).to receive(:generate_sku)
          subject
        }
      end

      context 'when sku exists' do
        let(:state) { :published }

        specify {
          expect{ subject }.not_to change{ product.sku }
        }

        specify {
          expect(product).not_to receive(:generate_sku)
          subject
        }
      end
    end
  end

  describe '#recalculate_price_for_the_euro' do
    let(:product) { create :product, :draft }

    subject { product.update_attributes(params_new_values) }

    context 'when we have all needed depends' do
      let(:params_new_values) { { state: 'published' } }

      it 'should be receive recalculate_price_for_the_euro' do
        expect(product).to receive(:recalculate_price_for_the_euro)
        subject
      end
    end

    context 'when we have invalid depends' do
      let(:params_new_values) { { state: 'published', euro_price: 0, euro_rate: 0 } }

      it 'should not be receive recalculate_price_for_the_euro' do
        expect(product).not_to receive(:recalculate_price_for_the_euro)
        subject
      end
    end
  end

  describe '.sort_by' do
    let!(:popular) { create :product, :popular }
    let!(:cheap) { create :product, :cheap }

    subject { Product.sort_by(how_sort).first }

    shared_examples_for 'not_receive_any_scopes' do
      described_class::HOWSORT.each do |how_sort|
        it 'should not be receive .sort_by' do
          expect(Product).not_to receive(:"#{ how_sort }")
          subject
        end
      end
    end

    context 'when sort by popular' do
      let(:how_sort) { 'popular' }

      its(:id) { popular.id }
    end

    context 'when sort by new_products' do
      let(:how_sort) { 'new_products' }

      its(:id) { popular.id }
    end

    context 'when sort by price_reduction' do
      let(:how_sort) { 'price_reduction' }

      its(:id) { cheap.id }
    end

    context 'when sort by price_increase' do
      let(:how_sort) { 'price_increase' }

      its(:id) { popular.id }
    end

    context 'when sort by nil' do
      let(:how_sort) { nil }

      it_behaves_like 'not_receive_any_scopes'
    end

    context "when Product::HOWSORT don't include sort by param" do
      let(:how_sort) { Faker::Lorem.word }

      it_behaves_like 'not_receive_any_scopes'
    end
  end

  describe '.by_brand' do
    let!(:brand) { create :brand }
    let!(:product_with_existing_brand) { create :product, brand: brand }
    let!(:product) { create :product }

    subject { Product.by_brand brand_id }

    context 'when brand id is not nil' do
      let(:brand_id) { brand.id }

      specify { expect(subject).to include(product_with_existing_brand) }
      specify { expect(subject).not_to include(product) }
    end

    context 'when brand id si nil' do
      let(:brand_id) { nil }

      specify { expect(subject).to be_empty }
    end
  end

  describe '.has_in_stores' do
    let!(:product_in_stores) { create :product, :with_stores }
    let!(:product) { create :product }

    subject { described_class.has_in_stores }

    specify { expect(subject).to include(product_in_stores) }
    specify { expect(subject).not_to include(product) }
  end

  describe '.for_yandex_market' do
    let!(:for_yandex_market) { create :product }
    let!(:not_for_yandex_market) { create :product, :not_for_yandex_market }

    subject { described_class.for_yandex_market }

    specify { expect(subject).to include(for_yandex_market) }
    specify { expect(subject).not_to include(not_for_yandex_market) }
  end
end
