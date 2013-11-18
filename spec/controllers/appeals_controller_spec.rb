require 'spec_helper'

describe AppealsController, "user authenticated" do
	login_user
	render_views
	context "doing GET on #index" do
		it "is logged in" do
			get :index
			subject.current_user.should_not be_nil
		end

		it "returns a list of my send requests not accepted/dinied" do
			user = FactoryGirl.create(:user)
			user2 = FactoryGirl.create(:user)
			request = FactoryGirl.create(:appeal, user: subject.current_user, receiver_id: user.id)
			request2 = FactoryGirl.create(:appeal, user: subject.current_user, receiver_id: user2.id)
			get :index
			ids = assigns(:appeals).collect{ | request | request.user.id }
			expect(ids).to eq( [subject.current_user.id,  subject.current_user.id] )
		end

		it "returns an empty list if all my requests are accepted/denied" do
			user = FactoryGirl.create(:user)
			user2 = FactoryGirl.create(:user)
			request = FactoryGirl.create(:appeal, user: subject.current_user, receiver_id: user.id, is_accepted: true)
			request2 = FactoryGirl.create(:appeal, user: subject.current_user, receiver_id: user2.id, is_accepted: true)
			get :index
			assigns(:appeals).should be_empty
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
			}.to change(Appeal, :count).by(1)
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
			}.not_to change(Appeal, :count).by(1)
		end

		it "redirects to users_path" do
			post :create, friend_id: 0
			response.should redirect_to users_path
		end
	end
end

describe AppealsController, "user no authenticated" do
	render_views

	before :each do
		get :index
	end

	it "redirects to login page" do
		response.should redirect_to new_user_session_path
	end
end