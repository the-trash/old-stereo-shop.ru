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

    it "assigns @meta" do
      get :index
      expect(assigns(:meta).keys.sort).to eq %i(keywords seo_description seo_title)
    end
  end

end
