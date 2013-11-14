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
			request = FactoryGirl.create(:request, user: subject.current_user)
			request2 = FactoryGirl.create(:request, user: subject.current_user, receiver_id: user.id)

			ids = assigns(:requests).collect{ | request | request.user.id }
			expect(ids).to eq( [subject.current_user.id,  subject.current_user.id] )
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