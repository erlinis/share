require "spec_helper"

describe ApplicationController do
 
  controller do
    def show
      raise ActiveRecord::RecordNotFound
    end
    
    def edit
      raise ActiveRecord::RecordNotFound
    end

    def update
      raise ActiveRecord::RecordNotFound
    end
  end

  describe "handling ActiveRecord exceptions when record not found" do
    before(:each) do
      @not_found_template = "#{Rails.root}/public/404.html"
    end

    it "should render the /404.html page" do
      get :show , id: 999
      response.should render_template(:file => @not_found_template)
    end

    it "should render the /404.html page" do
      get :edit , id: 999
      response.should render_template(:file => @not_found_template)
    end

    it "should render the /404.html page" do
      get :update , id: 999
      response.should render_template(:file => @not_found_template)
    end
  end

end