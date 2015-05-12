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

    it_behaves_like 'a successful render index template'
  end

  context 'get /products/:id' do
    before { get :show, id: product.id }

    it 'assigns @product' do
      expect(assigns(:product)).to eq(product)
    end

    it 'assigns @show_presenter' do
      expect(assigns(:show_presenter)).to eq(Products::ShowPresenter.new(product))
    end

    it 'not assigns @additional_option_value' do
      expect(assigns(:additional_option_value)).to be_nil
    end

    it 'not assigns @product_new_values' do
      expect(assigns(:product_new_values)).to be_nil
    end

    it_behaves_like 'a successful request'
    it_behaves_like 'a successful render show template'

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

    context 'when user authorized' do
      let(:user) { create :user }

      # TODO: refoctor me!
      before do
        sign_in user
        session[:user] = {}
        session[:user]['product_ids'] = [product.id]
        get :show, id: product.id
      end

      specify { expect(session[:user]['product_ids']).to eq([product.id]) }

      it_behaves_like 'a successful request'
      it_behaves_like 'a successful render show template'
    end
  end
end
