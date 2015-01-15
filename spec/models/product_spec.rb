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
    %i(title description product_category_id admin_user_id brand_id).each do |f|
      it { should validate_presence_of(f) }
    end

    %i(products_stores characteristics_products).each do |r|
      it { should accept_nested_attributes_for(r).allow_destroy(true) }
    end
  end

  it { should delegate(:title).to(:product_category).with_prefix }

  describe 'instance methods' do
    let!(:product) { create(:product) }

    describe '#make_characteristics_tree' do
      let!(:product_with_caracteristics) { create(:product, :with_caracteristics) }

      subject { product_with_caracteristics.make_characteristics_tree }

      it 'include categories' do
        expect(subject.first[:category]).to eq(CharacteristicCategory.order(id: :asc).first)
      end

      it 'include characteristics' do
        expect(subject.first[:characteristics].first[:characteristic]).
          to eq(CharacteristicCategory.order(id: :asc).first.characteristics.first)
      end

      it 'include characteristic value' do
        expect(subject.first[:characteristics].first[:characteristic_value]).
          to eq(
            CharacteristicCategory.order(id: :asc).first.characteristics.first.
              characteristics_products.first
            )
      end

      it 'return empty array' do
        expect(product.make_characteristics_tree).to eq([])
      end
    end

    describe '#make_stores' do
      let!(:product_with_stores) { create(:product, :with_stores) }

      it 'include store' do
        expect(product_with_stores.make_stores.first[:store]).
          to eq(Store.order_by.first)
      end

      it 'include store_count' do
        expect(product_with_stores.make_stores.first[:store_count]).
          to eq(ProductsStore.find_by(product_id: product_with_stores.id, store_id: Store.first.id))
      end

      it 'return empty array' do
        expect(product.make_stores).to eq([])
      end
    end
  end

  describe '#save' do
    let(:product) { build :product, state }

    subject { product.save }

    shared_examples_for 'receive_increment_product_category_cache_counters' do
      it 'should be receive #increment_product_category_cache_counters' do
        expect(product).to receive(:increment_product_category_cache_counters)
        subject
      end
    end

    shared_examples_for 'not_to_receive_increment_product_category_cache_counters' do
      it 'should not be receive #increment_product_category_cache_counters' do
        expect(product).not_to receive(:increment_product_category_cache_counters)
        subject
      end
    end

    shared_examples_for 'receive_recalculate_product_category_cache_counters' do |state|
      context 'when we change state' do
        before { subject }

        it 'should be receive #recalculate_product_category_cache_counters' do
          expect(product).to receive(:recalculate_product_category_cache_counters)
          product.send(:"#{state}!")
        end
      end
    end

    shared_examples_for 'not_to_receive_recalculate_product_category_cache_counters' do |state|
      context 'when we change state' do
        before { subject }

        it 'should not be receive #recalculate_product_category_cache_counters' do
          expect(product).not_to receive(:recalculate_product_category_cache_counters)
          product.send(:"#{state}!")
        end
      end
    end

    shared_examples_for 'product_with_specific_state' do |state, to_state, *args|
      context 'when product with specific state' do
        let(:state) { state}

        it_behaves_like "#{ args[0] }receive_increment_product_category_cache_counters"
        it_behaves_like "#{ args[1] }receive_recalculate_product_category_cache_counters", to_state
      end
    end

    context 'when product has published or removed state' do
      it_behaves_like 'product_with_specific_state', :published, :removed
      it_behaves_like 'product_with_specific_state', :removed, :published
    end

    context 'when product has state not equal published and removed' do
      it_behaves_like 'product_with_specific_state', :draft, :published, 'not_to_'
      it_behaves_like 'product_with_specific_state', :moderated, :published, 'not_to_'
    end
  end
end
