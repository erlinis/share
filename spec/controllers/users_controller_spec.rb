require 'spec_helper'

describe UsersController, "user authenticated" do

  	login_user
	context "doing GET on #index" do
		it "is logged in" do
			get :index
			subject.current_user.should_not be_nil
		end

		it "returns a list of registered users but me" do
			u = FactoryGirl.create(:user)
			u2 = FactoryGirl.create(:user)
			get :index
			ids = assigns(:users).collect{ | user | user.id }
			expect(ids).to eq([u.id, u2.id])
		end
	end

	context "doing GET to #show" do
		before :each do
			@user = FactoryGirl.create(:user)
			get :show, id: @user
		end

		it "is logged in" do
			subject.current_user.should_not be_nil
		end

		it "finds a valid user" do
			assigns(:user).should_not be_nil
		end

		it "finds the requested user" do
			assigns(:user).should == @user
		end
	end
end

describe UsersController, "user no authenticated" do
	it "redirects to login page where visiting index" do
		get :index
		response.should redirect_to new_user_session_path
	end

	it "redirects to login page where visiting show" do
		get :show, id: 0
		response.should redirect_to new_user_session_path
	end
end