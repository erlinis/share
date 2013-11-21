require 'spec_helper'

describe PendingAppealsController do
	context "with a authenticated user" do
		login_user

		context "doing GET to #index" do
			it "is logged in" do
				get :index
				subject.current_user.should_not be_nil
			end

			it "returns a list my pending appeals" do
				appeal1 = FactoryGirl.create(:appeal, receiver_id: subject.current_user.id)
				appeal2 = FactoryGirl.create(:appeal, receiver_id: subject.current_user.id)
				get :index
				ids = assigns(:appeals).collect{ | appeal | appeal.receiver.id }
				expect(ids).to eq( [subject.current_user.id,  subject.current_user.id] )
			end

			it "returns a empty list my pending appeals if accepted/denied all" do
				appeal1 = FactoryGirl.create(:appeal, receiver_id: subject.current_user.id, is_accepted: true)
				appeal2 = FactoryGirl.create(:appeal, receiver_id: subject.current_user.id, is_accepted: true)
				get :index
				assigns(:appeals).should be_empty
			end
		end

		context "doing PUT to update" do
			before :each do
				@myappeal = FactoryGirl.create(:appeal, receiver_id: subject.current_user.id)
			end

			it "is logged in" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: true)
				subject.current_user.should_not be_nil
			end

			it "sets a appeals as accepted" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: true)
				@myappeal.reload
				@myappeal.is_accepted.should be_true
			end

			it "sets a appeal as rejected" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: false)
				@myappeal.reload
				@myappeal.is_accepted.should be_false
			end

			it "redirects to index" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: true)
				response.should redirect_to pending_appeals_path
			end

			it "send a email if appeal was accepted" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: true)
				ActionMailer::Base.deliveries.last.to.should == [@myappeal.user.email]
			end

			it "not send a email if appeal was rejected" do
				put :update, id: @myappeal, appeal: FactoryGirl.attributes_for(:appeal, is_accepted: false)
				ActionMailer::Base.deliveries.last.to.should_not == [@myappeal.user.email]
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
				appeal = FactoryGirl.create(:appeal)
				put :update, id: appeal
				response.should redirect_to new_user_session_path
			end
		end
	end
end
