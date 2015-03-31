describe WelcomeController, type: :controller do
  it "derived from FrontController" do
    expect(controller).to be_a_kind_of(FrontController)
  end

  describe "GET index" do
    before { get :index }

    it_behaves_like 'a successful request'
  end
end
