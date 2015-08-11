describe CartServiceObject do
  let(:user) { nil }
  let(:session) { {} }
  let(:params) { {} }

  subject { described_class.new(user, session, params).current_cart }

  shared_examples_for 'generate right cart' do
    specify { expect{subject}.to change{Cart.count}.from(0).to(1) }
    it_behaves_like 'has right token in session'
  end

  shared_examples_for 'has right token in session' do
    it 'should has right token in session' do
      subject
      expect(session[:cart_token]).to eq subject.session_token
    end
  end

  shared_examples_for 'carts count should not change' do |count|
    specify { expect{subject}.not_to change{Cart.count}.from(count) }
  end

  it_behaves_like 'generate right cart'

  context 'when user exists' do
    let(:user) { create :user }

    it_behaves_like 'generate right cart'

    context 'when user has cart' do
      let!(:cart) { create :cart, user: user }

      it_behaves_like 'carts count should not change', 1
      it_behaves_like 'has right token in session'
    end
  end

  context 'when params has token' do
    let(:params) { { cart_token: SecureRandom.urlsafe_base64(nil, false) } }

    it_behaves_like 'carts count should not change', 0

    context 'when cart exists with token from params' do
      let!(:cart) { create :cart, :without_user, session_token: params[:cart_token] }

      it_behaves_like 'carts count should not change', 1

      specify { is_expected.to eq cart }

      it 'should has right params token in session' do
        subject
        expect(session[:cart_token]).to eq params[:cart_token]
      end
    end
  end

  context 'when session has token' do
    let(:session) { { cart_token: SecureRandom.urlsafe_base64(nil, false) } }

    it_behaves_like 'generate right cart'

    context 'when cart exists with token from session' do
      let!(:cart) { create :cart, :without_user, session_token: session[:cart_token] }

      it_behaves_like 'carts count should not change', 1
    end
  end
end
