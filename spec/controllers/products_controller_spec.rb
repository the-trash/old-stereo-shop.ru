describe ProductsController do
  let(:product) { FactoryGirl.create(:product) }

  context 'GET /products' do
    before { get :index }

    it 'assigns @products' do
      expect(assigns(:products)).to include(product)
    end

    it 'render index template' do
      expect(response).to render_template('index')
    end
  end

  context 'get /products/:id' do
    before { get :show, id: product.id }

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'render show template' do
      expect(response).to render_template('show')
    end
  end
end
