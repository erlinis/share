class RequestsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@requests = current_user.requests
	end

	def create
		@request = current_user.requests.build(:receiver_id => params[:friend_id])
		if @request.save
			flash[:notice] = 'Successfully Saved'
		else
			flash[:error] = "Error"
		end
		redirect_to users_path
	end
end
