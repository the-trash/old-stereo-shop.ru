describe BrandsController do
  let(:brand) { create :brand }
  let!(:product) { create :product, brand: brand }

  context 'GET /brands' do
    before { get :index }

    it 'assigns @brands' do
      expect(assigns(:brands)).to include(brand)
    end

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render index template'
  end

  context 'GET /brands/:id' do
    before { get :show, id: brand.id }

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render show template'

    it 'assigns @brand' do
      expect(assigns(:brand)).to eq(brand)
    end

    it 'assigns @products' do
      expect(assigns(:products)).to include(product)
    end
  end
end
