describe ProductsController do
  let!(:product) { FactoryGirl.create(:product, :published) }

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
      expect(assigns(:stores)).to eq(product.make_stores)
    end

    it 'assigns @characteristics' do
      expect(assigns(:characteristics)).to eq(product.make_characteristics_tree)
    end

    it 'assigns @related_products' do
      expect(assigns(:related_products)).to eq(product.related_products)
    end

    it 'assigns @similar_products' do
      expect(assigns(:similar_products)).to eq(product.similar_products)
    end

    it 'render show template' do
      expect(response).to render_template('show')
    end
  end
end
