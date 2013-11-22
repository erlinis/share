class FriendsController < ApplicationController
	before_filter :authenticate_user!

	def index
		@friends = Appeal.where("user_id = :user or receiver_id = :user and is_accepted = true", user: current_user.id)
		# received_requests = Appeal.where("receiver_id = :user and is_accepted = true", user: current_user.id).map(&:user_id)
		# @friends = User.where(:id => [send_requests + received_requests])
	end
end
