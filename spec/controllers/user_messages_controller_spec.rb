require 'spec_helper'

describe UserMessagesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "on POST 'create'" do
    before(:each) do
      @valid_user_message_attr = FactoryGirl.attributes_for(:user_message)
      @invalid_user_message_attr = FactoryGirl.attributes_for(:invalid_user_message)
    end

    context "with valid data" do
      it "should get correct params to create a new user_message" do
        post :create, user_message: @valid_user_message_attr
        assigns(:user_message).message.should == "some message"
      end

      it "should create an user_message" do 
        expect{
          post :create, user_message: @valid_user_message_attr
          assigns(:user_message)
          }.to change(UserMessage,:count).by(1)
      end

      it "should return successful user_message created" do
        post :create, user_message: @valid_user_message_attr
        assigns(:user_message)
        flash[:notice].should == 'Great, we will spread yours words!'
      end
    end

    context "with invalid data" do
      it "should redirect to template new to correct the data" do 
        post :create, invalid_user_message: @invalid_user_message_attr
        assigns(:invalid_user_message)
        flash[:error].should == 'Hmm,it seems you forgot write something'
      end

      it "should redirect to template new to correct the data" do 
        post :create, invalid_user_message: @invalid_user_message_attr
        assigns(:invalid_user_message)
        response.should render_template :new
      end
    end
  end

end
