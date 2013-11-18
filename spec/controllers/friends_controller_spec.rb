require 'spec_helper'

describe FriendsController do
	render_views
	context "with a user logged in" do
		login_user

		context "doing GET to index" do

			it "is logged in" do
				get :index
				subject.current_user.should_not be_nil
			end

			it "returns a list of my friends" do
				user = FactoryGirl.create(:user)
				user2 = FactoryGirl.create(:user)

				appeal = FactoryGirl.create(:appeal, user: user, receiver_id: subject.current_user.id, is_accepted: true)
				appeal2 = FactoryGirl.create(:appeal, user: user2, receiver_id: subject.current_user.id, is_accepted: true)

				get :index
        ids = assigns(:friends).map(&:id)
				expect(ids).to eq([user.id, user2.id])
			end
		end
	end
end
