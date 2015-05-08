describe WelcomeController, type: :controller do
  it "derived from FrontController" do
    expect(controller).to be_a_kind_of(FrontController)
  end

  context 'when user authorized' do
    let(:user) { create :user }

    before { sign_in user }

    describe "GET index" do
      before { get :index }

      it_behaves_like 'a successful request'
    end
  end

  context "when user doesn't authorized" do
    describe "GET index" do
      before { get :index }

      it_behaves_like 'a successful request'
    end
  end
end
