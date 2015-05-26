require 'rails_helper'

RSpec.describe FrontController, :type => :controller do
  controller do
    def index
      render nothing: true
    end
  end

  describe "GET index" do
    it "assigns @settings" do
      get :index
      expect(assigns(:settings)).to eq($settings)
    end

    it "assigns @front_presenter" do
      get :index
      expect(assigns(:front_presenter)).to eq FrontPresenter.new nil, controller.params
    end
  end
end
