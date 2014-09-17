require 'rails_helper'

RSpec.describe WelcomeController, :type => :controller do
  it "derived from FrontController" do
    expect(controller).to be_a_kind_of(FrontController)
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
