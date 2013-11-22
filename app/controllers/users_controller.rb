class UsersController < ApplicationController

	before_filter :authenticate_user!

	def index
		send_requests = Appeal.where("user_id = :user and is_accepted = true", user: current_user.id).map(&:receiver_id)
		received_requests = Appeal.where("receiver_id = :user and is_accepted = true", user: current_user.id).map(&:user_id)
		@users = User.where("id not in(?)", send_requests + received_requests << current_user.id)
	end

	def show
		@user = User.find params[:id]
	end
end
