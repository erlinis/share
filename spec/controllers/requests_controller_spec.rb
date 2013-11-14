require 'spec_helper'

describe RequestsController, "user authenticated" do
	login_user
	render_views
	context "doing GET on #index" do
		before :each do
			get :index
		end

		it "is logged in" do
			subject.current_user.should_not be_nil
		end

		it "returns a list of my pending requests" do
			user = FactoryGirl.create(:user)
			user2 = FactoryGirl.create(:user)
			request = FactoryGirl.create(:request, user: subject.current_user, receiver_id: user.id)
			request2 = FactoryGirl.create(:request, user: subject.current_user, receiver_id: user2.id)

			ids = assigns(:requests).collect{ | request | request.user.id }
			expect(ids).to eq( [subject.current_user.id,  subject.current_user.id] )
		end
	end

	context "doing POST on create with a valid id" do
		before :each do
			@user = FactoryGirl.create(:user)
		end

		it "is logged in" do
			post :create, friend_id: @user.id
			subject.current_user.should_not be_nil
		end

		it "creates a new request" do
			expect{
				post :create, friend_id: @user.id
			}.to change(Request, :count).by(1)
		end

		it "redirects to users_path" do
			post :create, friend_id: @user.id
			response.should redirect_to users_path
		end
	end

	context "doing POST on create with a invalid id" do
		it "does not create a new request" do
			expect{
				post :create, friend_id: 0
			}.not_to change(Request, :count).by(1)
		end

		it "redirects to users_path" do
			post :create, friend_id: 0
			response.should redirect_to users_path
		end
	end
end

describe RequestsController, "user no authenticated" do
	render_views

	before :each do
		get :index
	end

	it "redirects to login page" do
		response.should redirect_to new_user_session_path
	end
end