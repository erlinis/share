class AppealsController < ApplicationController

	before_filter :authenticate_user!

	def index
		@appeals = current_user.appeals
	end

	def create
		@appeal = current_user.appeals.build(:receiver_id => params[:friend_id])
		if @appeal.save
			flash[:notice] = 'Successfully Saved'
		else
			flash[:error] = "Error"
		end
		redirect_to users_path
	end
end
