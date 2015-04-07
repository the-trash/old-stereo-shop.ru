describe ProductsController do
  let!(:product) { create(:product, :published) }
  let!(:last_review) { create :review, :published, recallable: product }
  let(:related_product) { create :product, :with_related, product: product }
  let(:similar_product) { create :product, :with_similar, product: product }
  let(:additional_option) { create :additional_option, :with_additional_value, product: product }

  context 'GET /products' do
    before { get :index }

    it 'assigns @products' do
      expect(assigns(:products)).to include(product)
    end

    specify { expect(assigns(:brands)).to include(product.brand) }

    it 'render index template' do
      expect(response).to render_template('index')
    end
  end

  context 'get /products/:id' do
    before { get :show, id: product.id }

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'assigns @stores' do
      expect(assigns(:stores)).to eq([])
    end

    it 'assigns @characteristics' do
      expect(assigns(:characteristics)).to eq([])
    end

    it 'assigns @related_products' do
      expect(assigns(:related_products)).to include(related_product)
    end

    it 'assigns @similar_products' do
      expect(assigns(:similar_products)).to include(similar_product)
    end

    it 'assigns @product_category' do
      expect(assigns(:product_category)).to eq(product.product_category)
    end

    it 'assigns @last_reviews' do
      expect(assigns(:last_reviews)).to include(last_review)
    end

    it 'assigns @additional_options' do
      expect(assigns(:additional_options)).to include(additional_option)
    end

    it 'not assigns @additional_option_value' do
      expect(assigns(:additional_option_value)).to be_nil
    end

    it 'not assigns @product_new_values' do
      expect(assigns(:product_new_values)).to be_nil
    end

    it 'render show template' do
      expect(response).to render_template('show')
    end

    context 'when params containe additional_option_value' do
      let(:additional_option_value) { additional_option.values.first }
      let(:attributes_value) { create :attributes_value, value: additional_option_value }

      before { get :show, id: product.id, additional_option_value: additional_option_value.id }

      it 'assigns @additional_option_value' do
        expect(assigns(:additional_option_value)).to eq(additional_option_value)
      end

      it 'assigns @product_new_values' do
        expect(assigns(:product_new_values)).to include(attributes_value)
      end
    end
  end
end
