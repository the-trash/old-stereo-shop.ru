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

      it 'include categories' do
        product_with_caracteristics
        expect(product_with_caracteristics.make_characteristics_tree.first[:category]).
          to eq(CharacteristicCategory.order(id: :asc).first)
      end

      it 'include characteristics' do
        expect(
          product_with_caracteristics.make_characteristics_tree.
          first[:characteristics].first[:characteristic]
        ).
          to eq(CharacteristicCategory.order(id: :asc).first.characteristics.first)
      end

      it 'include characteristic value' do
        expect(
          product_with_caracteristics.make_characteristics_tree.
            first[:characteristics].first[:characteristic_value]
        ).
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
end
