require 'spec_helper'

describe PendingRequestsController do
	context "with a authenticated user" do
		login_user

		context "doing GET to #index" do
			it "is logged in" do
				get :index
				subject.current_user.should_not be_nil
			end

			it "returns a list my pending requests" do
				request1 = FactoryGirl.create(:request, receiver_id: subject.current_user.id)
				request2 = FactoryGirl.create(:request, receiver_id: subject.current_user.id)
				get :index
				ids = assigns(:requests).collect{ | request | request.receiver.id }
				expect(ids).to eq( [subject.current_user.id,  subject.current_user.id] )
			end
		end

		context "doing PUT to update" do
			before :each do
				@myrequest = FactoryGirl.create(:request, receiver_id: subject.current_user.id)
			end

			it "is logged in" do
				put :update, id: @myrequest, request: FactoryGirl.attributes_for(:request, is_accepted: true)
				subject.current_user.should_not be_nil
			end

			it "sets a requests as accepted" do
				put :update, id: @myrequest, request: FactoryGirl.attributes_for(:request, is_accepted: true)
				@myrequest.reload
				@myrequest.is_accepted.should be_true
			end

			it "sets a request as rejected" do
				put :update, id: @myrequest, request: FactoryGirl.attributes_for(:request, is_accepted: false)
				@myrequest.reload
				@myrequest.is_accepted.should be_false
			end

			it "redirects to index" do
				put :update, id: @myrequest, request: FactoryGirl.attributes_for(:request, is_accepted: true)
				response.should redirect_to pending_requests_path
			end
		end
	end

	context "without a authenticated user" do
		context "redirects to login page" do
			it "redirects from index" do
				get :index
				response.should redirect_to new_user_session_path
			end

			it "redirects from update" do
				request = FactoryGirl.create(:request)
				put :update, id: request
				response.should redirect_to new_user_session_path
			end
		end
	end
end
